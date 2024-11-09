param name string
param location string = resourceGroup().location
param sku object
param kind string
param properties object = {}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: name
  location: location
  sku: sku
  kind: kind
  properties: properties
}

output id string = appServicePlan.id
output name string = appServicePlan.name
