param name string
param location string = resourceGroup().location
param existingAppServicePlanId string
@allowed(['Enabled', 'Disabled'])
param publicNetworkAccess string

resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: name
  location: location
  properties: {
    serverFarmId: existingAppServicePlanId
    publicNetworkAccess: publicNetworkAccess
    // virtualNetworkSubnetId: subnetId
    // vnetRouteAllEnabled: true
    // siteConfig: {
    //   linuxFxVersion: 'NODE|20-lts'
    // }
    // reserved: true
  }
}

output id string = appService.id
output name string = appService.name
