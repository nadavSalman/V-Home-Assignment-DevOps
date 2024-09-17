If the AKS cluster uses a managed identity, the kubelet identity is used for authenticating with ACR. 



❯ terraform state show module.K8sInfra.azurerm_container_registry.default | grep name
    admin_username                = null
    name                          = "tfqvaronisquetzalacr"
    resource_group_name           = "kubernetesvaronis"

❯ az acr import --name tfqvaronisquetzalacr --source docker.io/library/nginx:latest --image nginx:v1

❯ k config current-context 
varonis-aks

❯ kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx0-deployment
  labels:
    app: nginx0-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx0
  template:
    metadata:
      labels:
        app: nginx0
    spec:
      containers:
      - name: nginx
        image: tfqvaronisquetzalacr.azurecr.io/nginx:v1
        ports:
        - containerPort: 80
EOF
deployment.apps/nginx0-deployment created

❯



Trooble shoting :


1. Make sure AcrPull role assignment is created for identity

az role assignment list --scope /subscriptions/a0a57880-1a49-461b-a574-8c926ae8c347/resourceGroups/kubernetesvaronis/providers/Microsoft.ContainerRegistry/registries/tfqvaronisquetzalacr -o table


2. Make sure service principal isn't expired

❯ terraform state show module.K8sInfra.azurerm_kubernetes_cluster.default | grep name
    name                                = "varonis-aks"
    resource_group_name                 = "kubernetesvaronis"
        name                          = "default"
        temporary_name_for_rotation   = null
        admin_username = "azureadmin"

SP_ID=$(az aks show --resource-group kubernetesvaronis --name varonis-aks \
    --query servicePrincipalProfile.clientId -o tsv)
az ad sp credential list --id "$SP_ID" --query "[].endDate" -o tsv