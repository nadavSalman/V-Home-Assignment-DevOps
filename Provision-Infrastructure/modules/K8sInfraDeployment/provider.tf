terraform {
  required_version = ">=1.0"

  required_providers {
    kubernetes = {
      version = ">= 2.17.0"
    }
  }
}


provider "kubernetes" {
  host                   = var.aks_host
  cluster_ca_certificate = var.aks_cluster_ca_certificate
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["aks", "get-credentials", "--resource-group", var.aks_rg, "--name", var.aks_name]
    command     = "az"
  }
}