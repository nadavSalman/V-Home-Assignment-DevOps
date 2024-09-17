terraform {
  required_version = ">=1.0"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    kubernetes = {
      version = ">= 2.17.0"
    }
  }
}
