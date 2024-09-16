terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstatelqsp3ob5"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}


module "BackendStorageSystem" {
  source = "./modules/BackendStorageSystem"

  # Init module arguments
  rg_name = "rg-backend-storage-system-prd"
}


module "K8sInfra" {
  source = "./modules/K8s"

  rg_name = "kubernetesvaronis"
}