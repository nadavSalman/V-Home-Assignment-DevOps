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

Description 
* Authentication via GitHub Actions to Azure resources - Implemented via a service principal. The secret for authenticating with Azure is embedded into GitHub secrets. This step is required as a one-time onboarding step and for rotating the secret in the future.
* Azure resources communication - AKS and ACR resources support Microsoft Entra authentication. Therefore, we can utilize Managed Identity to eliminate the need for developers to manage credentials manually.