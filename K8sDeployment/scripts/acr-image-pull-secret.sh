#!/bin/bash
yaml_file="./Provision-Infrastructure/modules/DeploymentPrep/prep_deployment.yaml"

# Extract values using yq
ACR_NAME=$(yq eval '.AzureResources.ACR.name' "$yaml_file")

kubectl create secret docker-registry  acr-secret \
    --namespace default \
    --docker-server=$ACR_NAME.azurecr.io \
    --docker-username=$ARM_CLIENT_ID \
    --docker-password=$ARM_CLIENT_SECRET