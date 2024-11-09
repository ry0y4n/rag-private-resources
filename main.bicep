targetScope = 'subscription'

param resourceGroupName string = 'rg-p-openai_kp0-codewith6' 
param location string = 'japaneast'
param uniqueServiceName string = uniqueString(resourceGroupName)

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

module appASP 'module/app-service-plan.bicep' = {
  name: 'app-asp'
  scope: resourceGroup
  params: {
    name: 'asp-app-${uniqueServiceName}'
    location: location
    sku: {
      name: 'S1'
      capacity: 1
    }
    kind: 'windows'
  }
}

module funcASP 'module/app-service-plan.bicep' = {
  name: 'func-asp'
  scope: resourceGroup
  params: {
    name: 'asp-func-${uniqueServiceName}'
    location: location
    sku: {
      tier: 'ElasticPremium'
      name: 'EP1'
      size: 'EP1'
      family: 'EP'
    }
    kind: 'elastic'
    properties: {
      maximumElasticWorkerCount: 20
      reserved: true
    }
  }
}

module appService 'module/app-service.bicep' = {
  name: 'app-service'
  scope: resourceGroup
  params: {
    name: 'app-${uniqueServiceName}'
    location: location
    existingAppServicePlanId: appASP.outputs.id
    publicNetworkAccess: 'Disabled'
  }
}

module function 'module/function.bicep' = {
  name: 'function'
  scope: resourceGroup
  params: {
    functionAppName: 'function-${uniqueServiceName}'
    functionStorageAccountName: 'saforfunc${uniqueServiceName}'
    existingAppServicePlanId: funcASP.outputs.id
  }
}

module blobStorageAccount 'module/blob-storage.bicep' = {
  name: 'blob-storage-account'
  scope: resourceGroup
  params: {
    storageAccountName: 'saforblob${uniqueServiceName}'
    location: location
  }
}

module openAiModule 'module/aoai.bicep' = {
  scope: resourceGroup
  name: 'azure-openai'
  params: {
    location: 'westus3'
    openAiName: 'aoai-${uniqueServiceName}'
    openAiSku: 'S0'
    // gpt35ModelCapacity: 50
    // gpt35ModelVersion: '0125'
    gpt4oModelCapacity: 50
    gpt4oModelVersion: '2024-08-06'
  }
}

module cosmosDB 'module/cosmos-db.bicep' = {
  name: 'cosmos-db'
  scope: resourceGroup
  params: {
    location: location
    accountName: 'cosmos-${uniqueServiceName}'
    databaseName: 'database'
    containerName: 'container'
  }
}

module aiSearch 'module/ai-search.bicep' = {
  name: 'ai-search'
  scope: resourceGroup
  params: {
    name: 'aisearch-${uniqueServiceName}'
    location: location
  }
}

module docIntelligence 'module/doc-intelligence.bicep' = {
  name: 'doc-intelligence'
  scope: resourceGroup
  params: {
    name: 'doc-intelligence-${uniqueServiceName}'
    location: location
  }
}
