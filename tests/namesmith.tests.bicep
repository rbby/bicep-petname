// Local test entry point: run with `bicep test tests/petname.tests.bicep`
// (requires the experimental testFramework/assertions flags in tests/bicepconfig.json)

test petnameAssertions 'petname.assertions.bicep' = {
  params: {}
}
