param retentionInDays int = 30 // If you don't specify a retention period when you call this module, Azure will automatically keep your logs for 30 days.
param location string = resourceGroup().location // It defaults to the location of the Resource Group where you deploy it
param name string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: name
  location: location
  properties: {
    retentionInDays: retentionInDays
    sku: {
      name: 'PerGB2018' // Standard pay-as-you-go tier
    }
  }
}

output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id
