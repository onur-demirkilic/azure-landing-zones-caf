targetScope = 'tenant'
param location string = 'eastus'
param BasicSubscriptionId string = 'e2408b3a-9f44-486c-899a-7f9c862f07f3'

resource rootGroup 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'contoso-root' // This must be a unique ID
  properties: {
    displayName: 'My Organization Root'
  }
}

// Creating 3 main groups under rootGroup: Platform, Workloads, and Sandbox

resource platformGroup 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'contoso-platform'
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
  name: 'contoso-workload'
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
  name: 'contoso-sandbox'
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

// This calls hub Module.
module hub './layers/connectivity/connectivity.bicep' = {
  name: 'hub-deployment'
  scope: subscription(BasicSubscriptionId) 
  params: {
    location: location
  }
}

// This calls spoke Module.
module spoke './layers/workloads/spoke.bicep' = {
  name: 'spoke-deployment'
  scope: subscription(BasicSubscriptionId) 
  params: {
    location: location 
  }
} 

// This calls vnetPeering module
module vnetPeering './modules/vnetPeering.bicep' = {
  name: 'vnet-peering-deployment'
  scope: subscription(BasicSubscriptionId) 
  params: {
    hubVnetName: hub.outputs.hubVnetName
    hubVnetId: hub.outputs.hubVnetId
    hubResourceGroupName: hub.outputs.hubRGName
    spokeVnetName: spoke.outputs.spokeVnetName
    spokeVnetId: spoke.outputs.spokeVnetId
    spokeResourceGroupName: spoke.outputs.spokeRGName
  }
}

//Creating Management/Logging Resource Group
module loggingRg 'modules/resourceGroup.bicep'= {
  name:'logging-rg-deployment'
  scope: subscription(BasicSubscriptionId)
  params: {
    rgName: 'cloudcorp-logging-rg'
    location: location
  }
}

//this calls Logging module to create logAnalyticsWorkspace
module logging './modules/logging.bicep' = {
  scope: resourceGroup(BasicSubscriptionId, 'cloudcorp-logging-rg')
  name: 'log-analytics-workspace-deployment'
  params: {
    name: 'law-cloudcorp-001'
    retentionInDays: 31 //this overwrites the default 30 that defined in the module itself
  }
  dependsOn: [
    loggingRg
  ]
}
