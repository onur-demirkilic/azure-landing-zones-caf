targetScope = 'subscription'

param rgName string
param location string

resource rg 'Microsoft.Resources/resourcegroups@2023-07-01' = {
	name: rgName
	location: location
}

// "outout" the name so the networking module knows where to go
output name string = rg.name
