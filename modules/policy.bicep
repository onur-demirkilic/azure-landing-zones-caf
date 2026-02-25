targetScope = 'managementGroup' //telling the Bicep compiler to interact with MG.

resource blockExpensiveVMs 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'block-expensive-vms'
  properties: {
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3'
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
  name: 'allow-ca-and-us-regions'
  properties: {
    displayName: 'Restrict deployment to Canada and East US'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
    parameters: {
      listOfAllowedLocations: {
        value: [
          'canadacentral' // This is the Toronto data center
          'eastus'        // Your preferred US region
        ]
      }
    }
  }
}

