@description('The name of the Azure Function app.')
param functionAppName string

@description('The location into which the resources should be deployed.')
param location string = resourceGroup().location

@description('The language worker runtime to load in the function app.')
@allowed([
  'dotnet'
  'node'
  'python'
  'java'
])
param functionWorkerRuntime string = 'node'

@description('Specifies the OS used for the Azure Function hosting plan.')
@allowed([
  'Windows'
  'Linux'
])
param functionPlanOS string = 'Windows'

// @description('Specifies the Azure Function hosting plan SKU.')
// @allowed([
//   'EP1'
//   'EP2'
//   'EP3'
// ])
// param functionAppPlanSku string = 'EP1'

// @description('The name of the Azure Function hosting plan.')
// param functionAppPlanName string = 'asp-func-${uniqueString(resourceGroup().id)}'

@description('The name of the backend Azure storage account used by the Azure Function app.')
param functionStorageAccountName string

@description('Only required for Linux app to represent runtime stack in the format of \'runtime|runtimeVersion\'. For example: \'python|3.9\'')
param linuxFxVersion string = ''

param existingAppServicePlanId string

var functionContentShareName = 'function-content-share'
var isReserved = ((functionPlanOS == 'Linux') ? true : false)

resource functionStorageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: functionStorageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    publicNetworkAccess: 'Disabled'
    allowBlobPublicAccess: false
    networkAcls: {
      bypass: 'None'
      defaultAction: 'Deny'
    }
  }
}

resource share 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-05-01' = {
  name: '${functionStorageAccountName}/default/${functionContentShareName}'
  dependsOn: [
    functionStorageAccount
  ]
}

// resource functionAppPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
//   name: functionAppPlanName
//   location: location
//   sku: {
//     tier: 'ElasticPremium'
//     name: functionAppPlanSku
//     size: functionAppPlanSku
//     family: 'EP'
//   }
//   kind: 'elastic'
//   properties: {
//     maximumElasticWorkerCount: 20
//     reserved: isReserved
//   }
// }

resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
  kind: (isReserved ? 'functionapp,linux' : 'functionapp')
  properties: {
    reserved: isReserved
    serverFarmId: existingAppServicePlanId
    publicNetworkAccess: 'Disabled'
    // virtualNetworkSubnetId: functionSubnetId
    // vnetRouteAllEnabled: true
    siteConfig: {
      functionsRuntimeScaleMonitoringEnabled: true
      linuxFxVersion: (isReserved ? linuxFxVersion : json('null'))
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${functionStorageAccountName};AccountKey=${functionStorageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${functionStorageAccountName};AccountKey=${functionStorageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: functionContentShareName
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: functionWorkerRuntime
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~14'
        }
        {
          name: 'WEBSITE_VNET_ROUTE_ALL'
          value: '1'
        }
        {
          name: 'WEBSITE_CONTENTOVERVNET'
          value: '1'
        }
      ]
    }
  }
  dependsOn: [
    share
  ]
}

output functionId string = functionApp.id
output functionName string = functionApp.name
