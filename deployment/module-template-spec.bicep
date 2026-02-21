param location string = 'Germany West Central'

resource templateSpec 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: 'petname'
  location: location
  properties: {
    description: 'Template spec for petname module'
    displayName: 'Petname Module'
    metadata: {
      category: 'Petname'
    }
  }

  resource templateSpecVersion 'versions@2022-02-01' = {
    location: location
    name: '1.0'
    properties: {
      mainTemplate: loadJsonContent('../src/petname.json')
    }
  }
}
