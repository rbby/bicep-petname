targetScope = 'subscription'

// Create a resource group for the template spec
resource templateSpecRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'templateSpecRG'
  location: 'Germany West Central'
}

// Create a template spec
module templateSpecModule 'module-template-spec.bicep' = {
  scope: resourceGroup(templateSpecRG.name)
  params: {
    templateSpecRGName: templateSpecRG.name
    location: templateSpecRG.location
  }
}
