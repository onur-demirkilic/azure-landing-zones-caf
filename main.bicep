targetScope = 'tenant'
param location string = 'eastus'
param BasicSubscriptionId string

resource rootGroup 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'CloudCorp-Root' // This must be a unique ID
  properties: {
    displayName: 'My Organization Root'
  }
}

// Creating 3 main groups under rootGroup: Platform, Workloads, and Sandbox

resource platformGroup 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'CloudCorp-Platform'
  properties: {
    displayName: 'Platform'
    details: {
      parent: {
        id: rootGroup.id // This links it to the rootGroup resource we defined earlier
      }
    }
  }
}

resource workloadGroup 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'CloudCorp-Workload'
  properties: {
    displayName: 'Workload'
    details: {
      parent: {
        id: rootGroup.id // This links it to the rootGroup resource we defined earlier
      }
    }
  }
}

resource sandboxGroup 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'CloudCorp-Sandbox'
  properties: {
    displayName: 'Sandbox'
    details: {
      parent: {
        id: rootGroup.id // This links it to the rootGroup resource we defined earlier
      }
    }
  }
}

module orgGovernance './policy.bicep' = {
  name: 'org-governance-deployment'
  scope: rootGroup // This tells the module: "Run your code inside this group"
}

// Creating hubRG
module hubRG 'modules/resourceGroup.bicep' = {
  name:'hub-rg-deployment'
  scope: subscription(BasicSubscriptionId)
  params: {
    rgName:'cloudcorp-hub-rg'
    location: location
  }
}


// This calls hub Module.
module hub './layers/connectivity/connectivity.bicep' = {
  name: 'hub-deployment' // Deployment log name
  scope: resourceGroup(BasicSubscriptionId, 'cloudcorp-hub-rg')
  params: {
    name: 'hub-vnet-deployment'       // Deployment log name for the internal AVM module
    vnetName: 'vnet-hub-001'          // The actual name of the VNet resource 
    subnetName: 'AzureBastionSubnet'  // subnetName
  }
  dependsOn: [
    hubRG
  ] 
  }


// Creating spokeRG, which will be used for Workloads
module spokeRG 'modules/resourceGroup.bicep' = {
  name: 'spoke-rg-deployment'
  scope: subscription(BasicSubscriptionId)
  params: {
    rgName: 'cloudcorp-workload-rg'
    location:location
  }
}

// This calls spoke Module.
module spoke './layers/workloads/spoke.bicep' = {
  name: 'spoke-deployment'
  scope: resourceGroup(BasicSubscriptionId, 'cloudcorp-workload-rg') 
  params: {
    name: 'spoke-vnet-deployment'
    vnetName: 'vnet-spoke-001'
    subnetName: 'snet-workload-001'
  }
  dependsOn: [
    spokeRG // This ensures the RG exists first.
  ]
} 

// This calls vnetPeering module
module vnetPeering './modules/vnetPeering.bicep' = {
  name: 'vnet-peering-deployment'
  scope: subscription(BasicSubscriptionId) 
  params: {
    hubVnetName: hub.outputs.hubVnetName
    hubVnetId: hub.outputs.hubVnetId
    hubResourceGroupName: hubRG.outputs.name
    spokeVnetName: spoke.outputs.spokeVnetName
    spokeVnetId: spoke.outputs.spokeVnetId
    spokeResourceGroupName: spokeRG.outputs.name
  }
}

// Creating Management/Logging Resource Group
module loggingRg 'modules/resourceGroup.bicep'= {
  name:'logging-rg-deployment'
  scope: subscription(BasicSubscriptionId)
  params: {
    rgName: 'cloudcorp-logging-rg'
    location: location
  }
}

// This calls Logging module to create logAnalyticsWorkspace
module logging './modules/logging.bicep' = {
  scope: resourceGroup(BasicSubscriptionId, 'cloudcorp-logging-rg')
  name: 'log-analytics-workspace-deployment'
  params: {
    name: 'law-cloudcorp-001'
    retentionInDays: 31 // This overwrites the default 30 that defined in the module itself
  }
  dependsOn: [
    loggingRg
  ]
}
