// Local test entry point: run with `bicep test tests/unit/namesmith.tests.bicep`
// (requires the experimental testFramework/assertions flags in tests/unit/bicepconfig.json)

test namesmithAssertions 'namesmith.assertions.bicep' = {
  params: {}
}
