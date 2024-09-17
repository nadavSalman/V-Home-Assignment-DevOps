output "acr_name" {
  value = azurerm_container_registry.default.name
}

output "aks_name" {
  value = data.azurerm_kubernetes_cluster.this.name
}

output "aks_host" {
  value = data.azurerm_kubernetes_cluster.this.kube_config.0.host
}

output "aks_client_certificate" {
  value = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.client_certificate)
}

output "aks_client_key" {
  value = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.client_key)
}

output "aks_cluster_ca_certificate" {
  value = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)
}

output "kube_config" {
  value = data.azurerm_kubernetes_cluster.this.kube_config_raw
}

output "aks_cluster_name" {
  value = data.azurerm_kubernetes_cluster.this.name
}


output "subscription_id" {
  value       = data.azurerm_subscription.current.subscription_id
  description = "The ID of the current Azure subscription."
}

output "storage_account_name" {
  value = azurerm_storage_account.backend_system.name
}

output "storage_container_name" {
  value = azurerm_storage_container.restaurants_req_res_history.name
}


output "aks_rg_name" {
  value = azurerm_resource_group.k8s_rg.name
}