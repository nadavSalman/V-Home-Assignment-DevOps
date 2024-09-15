#!/bin/bash


# Sources : 
# https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret?product_intent=terraform#creating-a-service-principal-using-the-azure-cli

# Creating a Service Principal using the Azure CLI
source  .env
echo $TAREGT_SUBSCRIPTION 

az login

az account set --subscription=$TAREGT_SUBSCRIPTION 

# We can now create the Service Principal which will have permissions to manage resources in the specified Subscription using the following command:
az ad sp create-for-rbac -n ProvisionInfrastructure --role="Contributor" --scopes="/subscriptions/$TAREGT_SUBSCRIPTION"