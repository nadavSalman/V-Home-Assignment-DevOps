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
  rg-name = "rg-backend-storage-system-prd"
}