/*
  Generating several distinct names in a single deployment.

  main.bicep is deterministic per seed, so reusing one seed for N resources
  would give them all the same name. Vary the seed instead — here, by
  offsetting a base seed per loop index — and each resource gets its own
  name while the whole deployment stays reproducible for a given base seed.
*/

@description('Base seed; each storage account offsets from this so the deployment is reproducible.')
param baseSeed int = int(utcNow('yyyyMMddHHmmss'))

@description('Number of storage accounts to name.')
param storageAccountCount int = 3

module storageAccountNames '../main.bicep' = [
  for i in range(0, storageAccountCount): {
    name: 'storageAccountName-${i}'
    params: {
      wordCount: 2
      seed: baseSeed + i
    }
  }
]

output storageAccountNames array = [for i in range(0, storageAccountCount): storageAccountNames[i].outputs.name]
