targetScope = 'subscription'

param rgName string
param location string

resource rg 'Microsoft.Resources/resourcegroups@2023-07-01' = {
	name: rgName
	location: location
}

// "output" the name so we can refer it
output name string = rg.name
