// =============== OBS! not done/tested =================

param location string = resourceGroup().location
param apiManagementServiceName string
param LAWorkflowName string
param APIMProduct string
param NamedValueBEValue string
param NamedValueSigValue string
param apimXmlPolicyFile string = loadTextContent('../APIM/GameAPIPolicy.xml')


resource apiManagementService 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource GameAPIProduct 'Microsoft.ApiManagement/service/products@2020-12-01' existing ={
  name:'${apiManagementServiceName}/${APIMProduct}'
}


resource LAGameAPI 'Microsoft.ApiManagement/service/apis@2020-12-01'= {
  name: '${apiManagementServiceName}/${LAWorkflowName}'
  properties:{
    displayName:LAWorkflowName       
    path:LAWorkflowName    
    protocols:['https']
    authenticationSettings:{
      oAuth2AuthenticationSettings: []
      openidAuthenticationSettings: []
    }
    subscriptionKeyParameterNames:{
      header: 'Ocp-Apim-Subscription-Key'
      query: 'subscription-key'
    }
    isCurrent: true
    }
  }

  
// =============== Link API to Product ===============
resource GameAPIProductLink 'Microsoft.ApiManagement/service/products/apis@2020-12-01' = {
  name:LAWorkflowName
  parent:GameAPIProduct
  dependsOn:[LAGameAPI]
}

// ================= Named Values =================
// this is an issue with the values, have not figured out how to get backend valus in Bicep yet....
resource NamedValueSIG 'Microsoft.ApiManagement/service/namedValues@2022-04-01-preview' = {
  name: '${LAWorkflowName}-SIG'
  parent: apiManagementService
  properties: {
    displayName: '${LAWorkflowName}-SIG'
    secret: true
    tags: [
            'SIG'
    ]
    value: NamedValueSigValue
  }
}


resource NamedValueBackend 'Microsoft.ApiManagement/service/namedValues@2022-04-01-preview' = {
  name: '${LAWorkflowName}-BE'
  parent: apiManagementService
  properties: {
    displayName: '${LAWorkflowName}-BE'
    secret: true
    tags: [
            'BE'
    ]
    value: NamedValueBEValue
  }
}


//=============== Add policy with policy file ===============
// OBS! Policy file needs to be updated to match the Logic app backend
resource LaGameAPIPolicy 'Microsoft.ApiManagement/service/apis/policies@2020-12-01' = {
  name:'policy'
  parent:LAGameAPI
  properties:{
    value:apimXmlPolicyFile
    format:'rawxml'
  }
  } 


//=============== Create operations in APIM for the API ===============
// needed if openAPI specs is not used.

// ================= Add operation to APIM API =================
resource operation 'Microsoft.ApiManagement/service/apis/operations@2020-06-01-preview' = {
  name: 'gameapi'
  parent: LAGameAPI
  properties: {
    displayName: 'GameAPI'
    method: 'GET'
    urlTemplate: '/triggers/manual/invoke'
    templateParameters: []
    request: {
      queryParameters: [
        {
          name: 'id'
          type: 'String'
          values: [
            '1052'
          ]
        }
      ]
      headers: []
      representations: []
    }
    responses: []
  }
}
