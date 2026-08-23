// Local test entry point: run with `bicep test tests/namesmith.tests.bicep`
// (requires the experimental testFramework/assertions flags in tests/bicepconfig.json)

test namesmithAssertions 'namesmith.assertions.bicep' = {
  params: {}
}
