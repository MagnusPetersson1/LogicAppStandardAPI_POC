
# ================ some az commands to have at hand ================

# ================ Log in to Azure ================
az login

# ================ list tenants on account ================
az account tenant list

# ================ set subscription context ================
az account set --subscription <subscriptionId>

# ================ Create resource group ================
az group create -l WestEurope -n <resource group name>


# ================ Deploy the app sevice plan ================

az deployment sub create --location westeurope --template-file Deployment/Scaffolding/Main.bicep --parameter Deployment/Scaffolding/LAStandard.dev.properties.json

# ================ Deploy the code ================
az webapp deployment list-publishing-credentials --name <name> --resource-group <resource group> --subscription <subscription id>

az deployment group create --location <location ex. westeurope> --template-file Deployment/Scaffolding/Main.bicep --parameter Deployment/Scaffolding/LAStandard.dev.properties.json


# ================ deploy api to APIM ================

az deployment group create --resource-group <resource group> --template-file Deployment/APIM/GameAPI.bicep --parameters Deployment/APIM/GameApi.dev.parameter.json

# ================ get open api ================
# OBS! this only works for Logic app consumtion

 az rest -m POST -u https://management.azure.com/subscriptions/<subscription id>/resourceGroups/<Resource group>/providers/Microsoft.Logic/workflows/<LA workflow>/listSwagger?api-version=2016-06-01

