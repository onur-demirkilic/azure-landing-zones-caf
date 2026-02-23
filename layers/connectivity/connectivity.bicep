targetScope = 'subscription'

param location string = 'eastus'
param rgName string = 'contoso-hub-rg'

// 1. Create the Resource Group using local module
module hubRG '../../modules/resourceGroup.bicep' = {
	name: 'hub-rg-deployment'   //Deployment Label that I see in Azure Portal.
	params: {
		rgName: rgName
		location: location
	}
}

// 2. Create the hub VNet using the AVM Module
module hubVnet 'br/public:avm/res/network/virtual-network:0.5.1' = {
	name: 'hub-vnet-deployment'
	scope: resourceGroup(rgName) //deploying into the specific RG even target is set to subscription at top.
	dependsOn: [
		hubRG // Wait for the RG to be ready!
	]
	params: {
	name: 'vnet-hub-001'
	addressPrefixes: [
		'10.0.0.0/16'
	]
	subnets: [
		{
		name: 'AzureBastionSubnet'
		addressPrefix: '10.0.1.0/24'
		}
	]
	}
}

output hubVnetId string 	= hubVnet.outputs.resourceId
output hubVnetName string = hubVnet.outputs.name
output hubRGName string 	= hubRG.outputs.name
