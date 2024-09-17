resource "azurerm_kubernetes_cluster" "default" {
  name                              = "${var.name}-aks"
  location                          = azurerm_resource_group.k8s_rg.location
  resource_group_name               = azurerm_resource_group.k8s_rg.name
  dns_prefix                        = "${var.dns_prefix}-${var.name}-aks-${var.environment}"
  role_based_access_control_enabled = true
  oidc_issuer_enabled               = true
  workload_identity_enabled         = true

  default_node_pool {
    name            = "default"
    vm_size         = var.node_type
    node_count      = var.node_count
    os_disk_size_gb = 30
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  linux_profile {
    admin_username = var.username

    ssh_key {
      key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
    }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  depends_on = [azurerm_role_assignment.aks_network, azurerm_role_assignment.aks_acr]
}



data "azurerm_kubernetes_cluster" "this" {
  name                = azurerm_kubernetes_cluster.default.name
  resource_group_name = azurerm_resource_group.k8s_rg.name

  # Comment this out if you get: Error: Kubernetes cluster unreachable 
  # depends_on = [azurerm_kubernetes_cluster.default]
}


resource "local_file" "kubeconfig" {
  content  = data.azurerm_kubernetes_cluster.this.kube_config[0].raw_config
  filename = "~/.kube/config"
}
