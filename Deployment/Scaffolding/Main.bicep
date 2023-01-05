
// Setting target scope
targetScope = 'subscription'

@minLength(1)
param location string = 'westeurope'

param ResourceGroupName string = 'GameAPI'

param environment string

//=============== Create logging resource group  ===============
resource logRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${ResourceGroupName}-log-${environment}'
  location: location
}

//=============== Create Log Analytics workspace ===============
module LogAnalytics './LogAnalytics.bicep' = {
  name: 'LogWorkspaceDeployment'
  scope: logRg
}

//=============== Creatat resource group for the Logic App ===============
resource LArg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${ResourceGroupName}-LA-${environment}'
  location: location
}

//=============== Deploy the logic app service container ===============
module LAService './LAStandard_Runtime.bicep' = {
  name: 'LogicAppServiceDeployment'
  scope: LArg // Deploy to our new or existing RG
  params: { // Pass on shared parameters
    environment: environment
    name: ResourceGroupName
    logwsid: LogAnalytics.outputs.id
    location: location
  }
}

output logic_app string = LAService.outputs.app
output logic_plan string = LAService.outputs.plan
