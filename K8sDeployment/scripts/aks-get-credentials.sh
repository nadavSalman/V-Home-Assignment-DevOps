#!/bin/bash
# yaml_file="./Provision-Infrastructure/modules/DeploymentPrep/prep_deployment.yaml"

# Extract values using yq
resource_group_name=$(yq eval '.AzureResources.AKS.ResourceGroup' "$yaml_file")
aks_name=$(yq eval '.AzureResources.AKS.name' "$yaml_file")

echo "Resource Group Name for AKS: $resource_group_name"
echo "AKS Name: $aks_name"
echo "Resource Group Name for Backend Storage: $backend_storage_rg"

az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
az aks get-credentials --resource-group $resource_group_name  --name $aks_name