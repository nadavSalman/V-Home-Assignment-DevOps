# Varonis Home Assignment - DevOps

## Assignment Overview


Varonis Home Assignment - DevOps

Develop a simple system that manages a list of restaurants and their properties. e.g., address, style (Italian, French, Korean), vegetarian (yes/no), opening hours, deliveries, etc.

The system will have an API for querying with a subset of these parameters and return a recommendation for a restaurant that answers the criteria, including the time of the request to check if it is open.

e.g., “A vegetarian Italian restaurant that is open now”  should return a JSON object with the restaurant and all its properties:
```json
{
    "restaurantRecommendation": {
    "name": "Pizza Hut",
    "style": "Italian",
    "address": "Wherever Street 99, Somewhere",
    "openHour": "09:00",
    "closeHour": "23:00",
    "vegetarian": "Yes"
    }
}
```


* The assignment submission should be in a GIT repo that we can access; it could be yours or a dedicated one.Please include all code required to set up the system.

* The system has to be cloud-native, with a preference for Azure and a simple architecture that will require minimal maintenance.

* The system should be written in full IaC style. I should be able to fully deploy it on my own cloud instance without making manual changes. Use Terraform for configuring the required cloud resources.

* Some backend storage mechanisms should hold the history of all requests and returned responses.

* Consider that the backend data stored is highly confidential.
Make sure the system is secure.
However, there is no need for the user to authenticate with the system (Assume it’s a free public service)

* The system code should be deployed using an automatic CI\CD pipeline following any code change, including adding or updating restaurants.
The code should be ready for code review (as possible)

* Coding: Python \ PowerShell 
IaC: Terraform



---
<br/>
<br/>
<br/>

# Solution 

### Architecture

**Authentication**

![alt text](Images/authentication.png)

**Description** 
* Authentication via GitHub Actions to Azure resources - Implemented via a service principal. The secret for authenticating with Azure is embedded into GitHub secrets. This step is required as a one-time onboarding step and for rotating the secret in the future.
* Azure resources communication - AKS and ACR resources support Microsoft Entra authentication. Therefore, we can utilize Managed Identity to eliminate the need for developers to manage credentials manually.

---




<br/>
<br/>
<br/>



**Terraform Architecture**

GitHub Actions workflows manage Azure infrastructure with Terraform.


1. Create a new branch and check in the needed Terraform code modifications.
2. Create a Pull Request (PR) in GitHub once you're ready to merge your changes into your environment.
3. A GitHub Actions workflow will trigger to ensure your code is well formatted, internally consistent, and produces secure infrastructure. In addition, a Terraform plan will run to generate a preview of the changes that will happen in your Azure environment.
4. Once appropriately reviewed, the PR can be merged into your main branch.
5. Another GitHub Actions workflow will trigger from the main branch and execute the changes using Terraform.

**Onbording**

1. Create `Service Principal` for Githu action create resources on teh target subscription.
2. Terrafrom backend state - Create Azure blob storage as remote backend
    * Update `backend` block.
3. Ingest `secrets` into Github

---


**Steps**

1. Provision Azure resource : `Service Principal` [**Day 0**]
    * Create ENV var named TAREGT_SUBSCRIPTION with the target subscsription ID as value and save inisde a file name `.env`  under `Provision-Infrastructure` dir .
    * Run the script for creation `Service Principal` at `Provision-Infrastructure/scripts/init-service-principal.sh`, the script will load the env `TAREGT_SUBSCRIPTION` from teh `.env` file
    *  Extract the env from the az coomnd output 
```bash
./init-service-principal.sh
...

# The az command below will create an app registration and service principal
az ad sp create-for-rbac -n ProvisionInfrastructure --role="Owner"  --scopes="/subscriptions/$TAREGT_SUBSCRIPTION"

The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
{
  "appId": "***", # client_id
  "displayName": "ProvisionInfrastructure",
  "password": "***", # client_secret
  "tenant": "***" # tenant_id
}


These values map to the Terraform variables like so:

appId is the client_id defined above.
password is the client_secret defined above.
tenant is the tenant_id defined above.
```

Append the env varibels the .env file :

```bash
export TAREGT_SUBSCRIPTION='' # Subscription ID
export CLIENT_ID=""
export CLIENT_SECRET=""
export TENANT_ID=""
```

Test the `Service Principal` , using the script located at : `Provision-Infrastructure/scripts/test-service-principal.sh`

```bash
source  .env
az login --service-principal -u $CLIENT_ID -p $CLIENT_SECRET --tenant $TENANT_ID
az vm list-sizes --location westus
az account list-locations
az logout
```



2. Terrafrom backend state

In case the target subscription is a new one validate the providers below are registerd to alow resources creation :
```bash
az provider register --namespace Microsoft.Storage
az provider register --namespace Microsoft.Compute
az provider register --namespace Microsoft.Network
```


Run the script at : `Provision-Infrastructure/scripts/remote-state.sh` to create an Azure storage account and container:
```bash
RANDOM_STRING=$(head /dev/urandom | tr -dc a-z0-9 | head -c 10)
RESOURCE_GROUP_NAME=tfstate
STORAGE_ACCOUNT_NAME=tfstate$RANDOM_STRING
CONTAINER_NAME=tfstate

az group create --name $RESOURCE_GROUP_NAME --location eastus
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME
```


Update the Storage Account name to the backed block and commit you changes.
```terraform
  backend "azurerm" {
      resource_group_name  = "tfstate"
      storage_account_name = "<storage_account_name>"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
  }
```



Initialize `GitHu Action secrets`

```
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="12345678-0000-0000-0000-000000000000"
export ARM_TENANT_ID="10000000-0000-0000-0000-000000000000"
export ARM_SUBSCRIPTION_ID="20000000-0000-0000-0000-000000000000"
```
You cam use above env to investigate remote state interaction for example to run `terrafom init`.


Update github secrets. 
Navigate to The repo `Actions` > `Secrets and variables` > `Actions` , then click on `New repository secret` to set up nthe `ARM_*` above as secret for Flows (CI-CD).

![alt text](Images/GithubActionSecrets.png)

Provision Infrastructure:

There are two (CI-CD) flows that are automatically triggered to provision infrastructure using Terraform, according to the architecture diagram above.



**Validat Workload Identity**


```bash
❯ # azurerm_user_assigned_identity.backend_storage_system.client_id
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: backend-storage-system-sa
  namespace: default
  annotations:
    azure.workload.identity/client-id: cd67baa1-3a29-49ce-8b25-805e272ca0bb
EOF
serviceaccount/backend-storage-system-sa created
```


Deploy az-cli continer and exec  (With service account attached :  `spec.serviceAccountName`):
```bash
Varonis-Home-Assignment-DevOps/K8sDeployment on  main [!] 
❯ k get pods 
NAME                        READY   STATUS    RESTARTS   AGE
azure-cli-b95fb75c9-zfxs4   1/1     Running   0          4s

Varonis-Home-Assignment-DevOps/K8sDeployment on  main [!] 
❯ k exec -it azure-cli-b95fb75c9-zfxs4 -- sh
/ # az login --federated-token "$(cat $AZURE_FEDERATED_TOKEN_FILE)" --service-principal -u $AZURE_CLIENT_ID -t $AZURE_T
ENANT_ID

[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "ffddc7a9-43af-4b3e-b7a4-920460792882",
    "id": "a0a57880-1a49-461b-a574-8c926ae8c347",
    "isDefault": true,
    "managedByTenants": [],
    "name": "Azure subscription 1",
    "state": "Enabled",
    "tenantId": "ffddc7a9-43af-4b3e-b7a4-920460792882",
    "user": {
      "name": "cd67baa1-3a29-49ce-8b25-805e272ca0bb",
      "type": "servicePrincipal"
    }
  }
]
/ # 
/ # az storage blob list -c restaurants --account-name devtest2391276 

There are no credentials provided in your command and environment, we will query for account key for your storage account.
It is recommended to provide --connection-string, --account-key or --sas-token in your command as credentials.

You also can add `--auth-mode login` in your command to use Azure Active Directory (Azure AD) for authorization if your login account is assigned required RBAC roles.
For more information about RBAC roles in storage, visit https://docs.microsoft.com/azure/storage/common/storage-auth-aad-rbac-cli.

In addition, setting the corresponding environment variables can avoid inputting credentials in your command. Please use --help to get more information about environment variable usage.
[]
/ # 
```

Upload blob :

```bash
/ # echo "Varonis" >  varonis.txt
/ # cat varonis.txt 
Varonis
/ # az storage blob upload \
>   --account-name devtest2391276 \
>   --container-name restaurants \
>   --name "varonis" \
>   --file ./varonis.txt

There are no credentials provided in your command and environment, we will query for account key for your storage account.
It is recommended to provide --connection-string, --account-key or --sas-token in your command as credentials.

You also can add `--auth-mode login` in your command to use Azure Active Directory (Azure AD) for authorization if your login account is assigned required RBAC roles.
For more information about RBAC roles in storage, visit https://docs.microsoft.com/azure/storage/common/storage-auth-aad-rbac-cli.

In addition, setting the corresponding environment variables can avoid inputting credentials in your command. Please use --help to get more information about environment variable usage.
Finished[#############################################################]  100.0000%
{
  "client_request_id": "8423df30-7514-11ef-adb8-d28398960d69",
  "content_md5": "I2jFR/47b8Tx/JkgJFuo1w==",
  "date": "2024-09-17T16:47:24+00:00",
  "encryption_key_sha256": null,
  "encryption_scope": null,
  "etag": "\"0x8DCD7386860D6F1\"",
  "lastModified": "2024-09-17T16:47:24+00:00",
  "request_id": "ea975121-c01e-0089-2621-09d7c0000000",
  "request_server_encrypted": true,
  "version": "2022-11-02",
  "version_id": null
}
/ # 

/ # az storage blob list -c restaurants --account-name devtest2391276 

There are no credentials provided in your command and environment, we will query for account key for your storage account.
It is recommended to provide --connection-string, --account-key or --sas-token in your command as credentials.

You also can add `--auth-mode login` in your command to use Azure Active Directory (Azure AD) for authorization if your login account is assigned required RBAC roles.
For more information about RBAC roles in storage, visit https://docs.microsoft.com/azure/storage/common/storage-auth-aad-rbac-cli.

In addition, setting the corresponding environment variables can avoid inputting credentials in your command. Please use --help to get more information about environment variable usage.
[
  {
    "container": "restaurants",
    "content": "",
    "deleted": null,
    "encryptedMetadata": null,
    "encryptionKeySha256": null,
    "encryptionScope": null,
    "hasLegalHold": null,
    "hasVersionsOnly": null,
    ...
```

![alt text](Images/varonix-blob.png)


<br/>
<br/>
<br/>

**Validate ACR Image Pull Secret** 

Import an image into your ACR :
```bash
az acr import --name tfqvaronisquetzalacr --source docker.io/library/nginx:latest --image nginx:v1
```


```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: my-awesome-app-pod
  namespace: default
spec:
  containers:
    - name: main-app-container
      image: tfqvaronisquetzalacr.azurecr.io/nginx:v1
      imagePullPolicy: IfNotPresent
  imagePullSecrets:
    - name: acr-secret

EOF
```
Chek :

```bash
Varonis-Home-Assignment-DevOps on  main [!] 
❯ k describe pod my-awesome-app-pod | grep -e "pulled image"
  Normal  Pulled     110s  kubelet            Successfully pulled image "tfqvaronisquetzalacr.azurecr.io/nginx:v1" in 5.492s (5.492s including waiting)

Varonis-Home-Assignment-DevOps on  main [!]
```



Using GitHub Actions to streamline the CI/CD system.
<br/>
<br/>
<br/>

![alt text](Images/Flows.png)
![alt text](Images/ci-cd.png)



**App Blob Integration test**

```bash
Varonis-Home-Assignment-DevOps/RestaurantApp on  main via 🐍 v3.12.3 (venv) 
❯ curl 'http://restaurants.app/recommendation?style=Mexican&vegetarian=No&current_time=10:00' | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   225  100   225    0     0    149      0  0:00:01  0:00:01 --:--:--   149
{
  "massage": "The restaurant Pizza Hut , Is open ? : True.",
  "restaurantRecommendation": {
    "address": "Wherever Street 99, Somewhere",
    "closeHour": "23:00",
    "name": "Pizza Hut",
    "openHour": "09:00",
    "style": "Italian",
    "vegetarian": "Yes"
  }
}
```


![alt text](Images/blob-example.png)