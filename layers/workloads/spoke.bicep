targetScope = 'subscription'

param location string

// Create a RG for the Workload
module spokeRG '../../modules/resourceGroup.bicep' = {
  name: 'workload-rg-deployment'
  params: {
    rgName: 'contoso-workload-rg'
    location: location
  }
}

// Create a spoke VNet using the AVM Module
module spokeVnet 'br/public:avm/res/network/virtual-network:0.5.1' = {
  name: 'spoke-vnet-deployment'
  scope: resourceGroup('contoso-workload-rg') //deploying into the specific RG
  dependsOn: [
    spokeRG // Wait for the RG to be ready
  ]
  params: {
    name: 'vnet-spoke-001'
    addressPrefixes: [
      '10.1.0.0/16'
    ]
    subnets: [
      {
        name: 'snet-workload-001'
        addressPrefix: '10.1.1.0/24'
      }
    ]
  }
}

output spokeVnetId string   = spokeVnet.outputs.resourceId
output spokeVnetName string = spokeVnet.outputs.name
output spokeRGName string   = spokeRG.outputs.name
