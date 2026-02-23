// This file will be used for vnetPeering.bicep
targetScope = 'resourceGroup'

param localVnetName string
param remoteVnetId string
param peeringName string

resource peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  name: '${localVnetName}/${peeringName}'
  properties: {
    remoteVirtualNetwork: { id: remoteVnetId }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
  }
}
