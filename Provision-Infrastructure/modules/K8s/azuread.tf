resource "azurerm_user_assigned_identity" "aks" {
  location            = azurerm_resource_group.k8s_rg.location
  name                = "${random_pet.rg.id}-uai"
  resource_group_name = azurerm_resource_group.k8s_rg.name
  depends_on          = [azurerm_resource_group.k8s_rg]
}

resource "azurerm_role_assignment" "aks_network" {
  scope                = azurerm_resource_group.k8s_rg.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_role_assignment" "aks_acr" {
  scope                = azurerm_container_registry.default.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}


# Workload Identity
locals {
  identity_name = "backend-storage-system"
}

resource "azurerm_user_assigned_identity" "backend_storage_system" {
  name                = local.identity_name
  location            = azurerm_resource_group.k8s_rg.location
  resource_group_name = azurerm_resource_group.k8s_rg.name
}

resource "azurerm_federated_identity_credential" "backend_storage_system" {
  name                = local.identity_name
  resource_group_name = azurerm_resource_group.k8s_rg.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.default.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.backend_storage_system.id
  subject             = "system:serviceaccount:default:${local.identity_name}-sa"

  depends_on = [azurerm_kubernetes_cluster.default]
}

resource "azurerm_role_assignment" "blob_storage_access" {
  principal_id   = azurerm_user_assigned_identity.backend_storage_system.principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope          = azurerm_storage_account.your_storage_account.id
}