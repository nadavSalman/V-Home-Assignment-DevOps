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

  aks_name = module.K8sInfra.aks_cluster_name
  aks_rg = module.K8sInfra.aks_rg_name
  aks_host = module.K8sInfra.aks_host
  aks_cluster_ca_certificate = module.K8sInfra.aks_cluster_ca_certificate

}