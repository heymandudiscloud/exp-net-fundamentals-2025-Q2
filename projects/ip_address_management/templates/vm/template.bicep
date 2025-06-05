// ────────── Parameters ──────────

// Location
param location string

// Networking
param virtualNetworkName string
param addressPrefixes array
param subnets array
param subnetName string

param networkSecurityGroupName string
param networkSecurityGroupRules array

param networkInterfaceName1 string
param publicIpAddressName1 string
param publicIpAddressType string
param publicIpAddressSku string
param pipDeleteOption string
param nicDeleteOption string

// Virtual Machine
param virtualMachineName string
param virtualMachineName1 string
param virtualMachineComputerName1 string
param virtualMachineRG string
param virtualMachineSize string
param virtualMachine1Zone string

// OS and Disk
param osDiskType string
param osDiskDeleteOption string
param hibernationEnabled bool = false

// Admin credentials
param adminUsername string
@secure()
param adminPassword string

// Patch and security settings
param enablePeriodicAssessment string
param rebootSetting string
param securityType string
param secureBoot bool
param vTPM bool

// Image reference
param imagePublisher string 
param imageOffer string 
param imageSku string 
param imageVersion string

// ────────── Variables ──────────
var nsgId = resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', networkSecurityGroupName)
var subnetRef = '${resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks', virtualNetworkName)}/subnets/${subnetName}'

// ────────── Resources ──────────

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2020-05-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: networkSecurityGroupRules
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: subnets
  }
}

resource publicIpAddress1 'Microsoft.Network/publicIpAddresses@2020-08-01' = {
  name: publicIpAddressName1
  location: location
  sku: {
    name: publicIpAddressSku
  }
  zones: [
    virtualMachine1Zone
  ]
  properties: {
    publicIPAllocationMethod: publicIpAddressType
  }
}

resource networkInterface1 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  name: networkInterfaceName1
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetRef
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resourceId(resourceGroup().name, 'Microsoft.Network/publicIpAddresses', publicIpAddressName1)
            properties: {
              deleteOption: pipDeleteOption
            }
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgId
    }
  }
  dependsOn: [
    networkSecurityGroup
    virtualNetwork
    publicIpAddress1
  ]
}

resource virtualMachine1 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: virtualMachineName1
  location: location
  zones: [
    virtualMachine1Zone
  ]
  properties: {
    hardwareProfile: {
      vmSize: virtualMachineSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'fromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
        deleteOption: osDiskDeleteOption
      }
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: imageSku
        version: imageVersion
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface1.id
          properties: {
            deleteOption: nicDeleteOption
          }
        }
      ]
    }
    securityProfile: {
      securityType: securityType
      uefiSettings: {
        secureBootEnabled: secureBoot
        vTpmEnabled: vTPM
      }
    }
    additionalCapabilities: {
      hibernationEnabled: hibernationEnabled
    }
    osProfile: {
      computerName: virtualMachineComputerName1
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
      }
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

// ────────── Outputs ──────────
output adminUsername string = adminUsername
