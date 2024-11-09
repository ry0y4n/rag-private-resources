param name string
param location string = resourceGroup().location

resource doc_intelligence 'Microsoft.CognitiveServices/accounts@2024-06-01-preview' = {
  name: name
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'FormRecognizer'
  identity: {
    type: 'None'
  }
  properties: {
    customSubDomainName: name
    networkAcls: {
      defaultAction: 'Deny'
      ipRules: [ 
        {value: '20.3.165.95'}
        {value: '58.220.95.0/24'}
        {value: '64.215.22.0/24'}
        {value: '87.58.64.0/18'}
        {value: '94.188.131.0/25'}
        {value: '94.188.139.64/26'}
        {value: '94.188.248.64/26'}
        {value: '98.98.26.0/24'}
        {value: '98.98.27.0/24'}
        {value: '98.98.28.0/24'}
        {value: '101.2.192.0/18'}
        {value: '104.129.192.0/20'}
        {value: '112.137.170.0/24'}
        {value: '124.248.141.0/24'}
        {value: '128.177.125.0/24'}
        {value: '136.226.0.0/16'}
        {value: '137.83.128.0/18'}
        {value: '140.210.152.0/23'}
        {value: '147.161.128.0/17'}
        {value: '154.113.23.0/24'}
        {value: '165.225.0.0/17'}
        {value: '165.225.192.0/18'}
        {value: '167.103.0.0/16'}
        {value: '170.85.0.0/16'}
        {value: '185.46.212.0/22'}
        {value: '194.9.96.0/20'}
        {value: '194.9.112.0/22'}
        {value: '194.9.116.0/24'}
        {value: '196.23.154.64/27'}
        {value: '196.23.154.96/27'}
        {value: '197.98.201.0/24'}
        {value: '197.156.241.224/27'}
        {value: '198.14.64.0/18'}
        {value: '199.168.148.0/23'}
        {value: '209.55.128.0/18'}
        {value: '209.55.192.0/19'}
        {value: '211.144.19.0/24'}
        {value: '220.243.154.0/23'}
        {value: '221.122.91.0/24'}
      ]    
    }
    publicNetworkAccess: 'Enabled'
  }
}

output id string = doc_intelligence.id
output name string = doc_intelligence.name
