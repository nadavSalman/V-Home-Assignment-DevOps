output "acr_name" {
  value = azurerm_container_registry.default.name
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

