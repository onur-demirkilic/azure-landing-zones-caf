targetScope = 'resourceGroup'
param name string
param vnetName string
param subnetName string

// Create the hub VNet using the AVM Module
module hubVnet 'br/public:avm/res/network/virtual-network:0.5.1' = {
	name: name
	params: {
	name: vnetName
	addressPrefixes: [
		'10.0.0.0/16'
	]
	subnets: [
		{
		name: subnetName
		addressPrefix: '10.0.1.0/24'
		}
	]
	}
}

output hubVnetId string 	= hubVnet.outputs.resourceId
output hubVnetName string = hubVnet.outputs.name
