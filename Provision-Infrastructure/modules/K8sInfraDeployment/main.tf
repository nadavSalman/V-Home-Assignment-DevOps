# provider "helm" {
#   kubernetes {
#     host                   = var.aks_host
#     client_certificate     = var.aks_client_certificate
#     client_key             = var.aks_client_key
#     cluster_ca_certificate = var.aks_cluster_ca_certificate
#   }
# }

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}