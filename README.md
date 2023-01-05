# Azure Logic app standard 

This is an example on an Azure Logic App standard API with the 
basic dependencies for a Logic app standard application in Azure. It also contains the deployment of the API to API Management. The thought is that the API management is dived in three parts. One for API Management- the service. One for the surrounding resources such as products and user groups etc. This is the third part of the API representation. The API and the API Management gateway representation of that API. 

Requirements
* Azure CLI (az)
* Azure Biceps module
* Azure account
* VS code or any other text editor and a terminal

## Usage

The project is verry simple and only contain the bicep and configuration that is needed.
The command.sh contain the needed command to crate the “app service plan” and “API App instance” and using bicep and Azure CLI (az commands)

start with loging in to your Azure account

```bash
az login
```

select subscription

```bash
az account set --subscription <subscription id> 
```

Create resource group is included in bicep. So, this is not required to do with az command! 

```bash
az group create -l <locaton> -n <resource group name>
```

## For the App service 
To deploy the app service instance run the AppService.bicep file together with AppService-DEV.parameters.json in the Scaffolding folder. OBS! The *.parameters.json needs to be updated with your details. 

```bash
az deployment sub create --location westeurope --template-file Deployment/Scaffolding/Main.bicep --parameter Deployment/Scaffolding/LAStandard.dev.properties.json
```
## For API App  
To deploy API workflow … TBU.

## Deploy the code  
Deploy the code to the API App. Use VS code, use Az or any other of the ways that are available.

## For API Management representation  
To deploy API App, run GameAPIApp.bicep file together with GameAPIApp-DEV.parameters.json. OBS! *..parameters.json, GameAPIAppPolicy.xml,*.bicep needs to be updated with your details. 

```bash
az deployment group create --resource-group APIM-dev --template-file Deployment/APIM/GameAPI.bicep --parameters Deployment/APIM/GameApi.dev.parameter.json
```


## Contributing
This is just a repo for my own reference. If it can help anyone else, great. But it is only a POC to investigate API Logic app standard together with APIM and Bicep. It is not designed for production or even test usage but as a get started example. 

## License

[MIT](https://choosealicense.com/licenses/mit/)


