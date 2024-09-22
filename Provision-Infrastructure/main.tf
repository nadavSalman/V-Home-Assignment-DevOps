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

  subscription_id              = module.K8sInfra.subscription_id
  aks_name                     = module.K8sInfra.aks_name
  aks_rg_name                  = module.K8sInfra.aks_rg_name
  acr_name                     = module.K8sInfra.acr_name
  storage_account_name         = module.K8sInfra.storage_account_name
  container_name               = module.K8sInfra.storage_container_name
  storace_accoun_uai_client_id = module.K8sInfra.backend_storage_system_uai_client_id
}