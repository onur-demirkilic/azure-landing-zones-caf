targetScope = 'subscription'

param hubVnetName string
param hubResourceGroupName string
param spokeVnetName string
param spokeResourceGroupName string
param hubVnetId string
param spokeVnetId string

// Calling singlePeering worker for the Hub Side
module hubSidePeering './singlePeering.bicep' = {
  name:'hub-to-spoke-peering'
  scope: resourceGroup(hubResourceGroupName)
  params: {
    localVnetName: hubVnetName
    remoteVnetId: spokeVnetId
    peeringName: 'hub-to-spoke'
  }
}

// Calling singlePeering worker for the Spoke Side 
module spokeSidePeering './singlePeering.bicep' = {
  name:'spoke-to-hub-peering'
  scope: resourceGroup(spokeResourceGroupName)
  params: {
    localVnetName: spokeVnetName
    remoteVnetId: hubVnetId
    peeringName: 'spoke-to-hub'
  }
}
