param location string
param openAiName string
param openAiSku string
param gpt4oModelCapacity int
param gpt4oModelVersion string
// param gpt35ModelCapacity int
// param gpt35ModelVersion string

resource openAi 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: openAiName
  location: location
  kind: 'OpenAI'
  sku: {
    name: openAiSku
  }
  properties: {
    customSubDomainName: openAiName
    networkAcls: {
      defaultAction: 'Deny'
    }
    publicNetworkAccess: 'Disabled'
  }
}

// resource gpt35Model 'Microsoft.CognitiveServices/accounts/deployments@2023-10-01-preview' = {
//   parent: openAi
//   name: 'gpt-35-turbo'
//   sku: {
//     name: 'Standard'
//     capacity: gpt35ModelCapacity
//   }
//   properties: {
//     model: {
//       format: 'OpenAI'
//       name: 'gpt-35-turbo'
//       version: gpt35ModelVersion
//     }
//     versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
//     raiPolicyName: 'Microsoft.Default'
//   }
// }

resource gpt4oModel 'Microsoft.CognitiveServices/accounts/deployments@2023-10-01-preview' = {
  parent: openAi
  name: 'gpt-4o'
  sku: {
    name: 'Standard'
    capacity: gpt4oModelCapacity
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-4o'
      version: gpt4oModelVersion
    }
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
    raiPolicyName: 'Microsoft.Default'
  }
}

output aoaiId string = openAi.id
output aoaiName string = openAi.name
