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


resource blockExpensiveVMs 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'block-expensive-vms'
  scope: rootGroup // This applies the rule to your whole organization!
  properties: {
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad87-de616a28273f'
    parameters: {
      listOfAllowedSKUs: {
        value: [
          'Standard_B1s'
          'Standard_B2s'
        ]
      }
    }
  }
}

resource allowRegions 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'allow-toronto-and-us-regions'
  scope: rootGroup // Applying it to the root so everything follows this rule
  properties: {
    displayName: 'Restrict deployment to Canada and East US'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
    parameters: {
      listOfAllowedLocations: {
        value: [
          'canadacentral' // This is the Toronto data center! 🏙️
          'eastus'        // Your preferred US region
        ]
      }
    }
  }
}


