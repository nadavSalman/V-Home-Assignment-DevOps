terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstatelqsp3ob5"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}




module "K8sInfra" {
  source = "./modules/K8s"

  rg_name = "kubernetesvaronis"
}

module "K8sInfraDeployment" {
  source = "./modules/K8sInfraDeployment"

  aks_host                   = module.K8sInfra.aks_host
  aks_client_certificate     = module.K8sInfra.aks_client_certificate
  aks_client_key             = module.K8sInfra.aks_client_key
  aks_cluster_ca_certificate = module.K8sInfra.aks_cluster_ca_certificate
  aks_cluster_name           = module.K8sInfra.aks_cluster_name
  aks_resource_group         = module.K8sInfra.aks_rg_name
}