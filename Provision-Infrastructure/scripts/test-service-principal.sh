#!/bin/bash -x

# Soource : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret?product_intent=terraform#creating-a-service-principal-using-the-azure-cli

source  .env
az login --service-principal -u $CLIENT_ID -p $CLIENT_SECRET --tenant $TENANT_ID

# Once logged in as the Service Principal - we should be able to list the VM sizes by specifying an Azure region, for example here we use the West US region:

az vm list-sizes --location westus
az account list-locations

az logout