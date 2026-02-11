targetScope = 'tenant'

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

