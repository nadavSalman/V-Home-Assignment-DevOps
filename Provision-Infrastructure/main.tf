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

module "BackendStorageSystem" {
  source = "./modules/BackendStorageSystem"

  # Init module arguments
  rg_name = "rg-backend-storage-system-prd"

  depends_on = [module.K8sInfra]
}

