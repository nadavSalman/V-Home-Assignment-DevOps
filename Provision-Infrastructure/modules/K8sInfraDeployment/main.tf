resource "null_resource" "get_kubeconfig" {
  provisioner "local-exec" {
    command = "az aks get-credentials --resource-group ${var.aks_resource_group} --name ${var.aks_cluster_name}"
  }
}

provider "helm" {
  kubernetes {
    config_path = pathexpand("~/.kube/config")
  }
}


# provider "helm" {
#   kubernetes {
#     host                   = var.aks_host
#     client_certificate     = var.aks_client_certificate
#     client_key             = var.aks_client_key
#     cluster_ca_certificate = var.aks_cluster_ca_certificate
#   }
# }