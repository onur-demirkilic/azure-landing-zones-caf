targetScope = 'resourceGroup'
param name string
param vnetName string
param subnetName string

// Create a spoke VNet using the AVM Module
module spokeVnet 'br/public:avm/res/network/virtual-network:0.5.1' = {
  name: name
  params: {
    name: vnetName
    addressPrefixes: [
      '10.1.0.0/16'
    ]
    subnets: [
      {
        name: subnetName
        addressPrefix: '10.1.1.0/24'
      }
    ]
  }
}

output spokeVnetId string   = spokeVnet.outputs.resourceId
output spokeVnetName string = spokeVnet.outputs.name
