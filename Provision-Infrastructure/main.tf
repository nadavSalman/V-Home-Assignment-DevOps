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




module "DeploymentPrep" {
  source = "./modules/DeploymentPrep"

  subscription_id      = module.K8sInfra.subscription_id
  ask_name             = module.K8sInfra.aks_name
  aks_rg_name          = module.K8sInfra.aks_rg_name
  acr_name             = module.K8sInfra.acr_name
  storage_account_name = module.K8sInfra.storage_account_name
  continer_name        = module.K8sInfra.storage_container_name

}

# module "K8sInfraDeployment" {
#   source = "./modules/K8sInfraDeployment"

#   aks_name                   = module.K8sInfra.aks_cluster_name
#   aks_rg                     = module.K8sInfra.aks_rg_name
#   aks_host                   = module.K8sInfra.aks_host
#   aks_cluster_ca_certificate = module.K8sInfra.aks_cluster_ca_certificate
#   subscription_id            = module.K8sInfra.subscription_id

# }