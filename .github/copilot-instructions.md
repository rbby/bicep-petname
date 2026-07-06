# Bicep Petname Module

## Project Context

This is a Bicep module for generating human-readable, random names for Azure resources. The implementation is inspired by Dustin Kirkland's original **petname** utility, adapted for Azure Bicep Infrastructure as Code.

**Purpose**: Provide consistent, memorable, and unique naming for Azure resources using combinations of adverbs, adjectives, and names (e.g., `happily-golden-eagle`, `bright-falcon`).

**Architecture**:
- Pure Bicep implementation using exported functions
- Deterministic pseudo-random generation based on seed values
- No external dependencies or runtime requirements
- Supports 1-4 word combinations with customizable separators

## Critical Development Patterns

### Naming Generation
1. **Word Lists**: Three arrays store word categories (adjectives, adverbs, names)
2. **Seeding**: Uses seed parameter for deterministic randomization
3. **Index Calculation**: The seed is normalized to a non-negative value (double modulo against the prime 715827883, so negative seeds are valid) and mixed with Knuth's multiplicative constant 2654435761 before the final modulo, so nearby seeds (e.g. consecutive `utcNow` timestamps) map to unrelated words
4. **Composition**: Functions combine words with separators based on word count

### Function Exports
All key functions are marked with `@export()` decorator:
- `getRandomIndex()` - Core randomization logic
- `getAdverb()`, `getAdjective()`, `getName()` - Word selectors
- `generateTwoWords()`, `generateThreeWords()`, `generateFourWords()` - Composition functions

### Seed Management
- Default seed uses `utcNow('yyyyMMddHHmmss')` for time-based uniqueness
- Custom seeds enable reproducible names
- Offset seeds (+1, +2, +3) ensure different words from same base seed

## Development Guidelines

### Adding New Words
When adding words to any list:
- Keep words simple, positive, and professional
- Avoid offensive, ambiguous, or confusing terms
- Maintain alphabetical order for readability (the `names` list is grouped by word length, alphabetical within each group)
- Test with various seed values to ensure distribution

### Modifying Generation Logic
- Preserve deterministic behavior - same seed = same name
- Maintain backward compatibility with existing seed values
- Update all relevant exported functions if changing core logic
- Document any changes to randomization algorithm

### Testing Approach
Use [test-petname.bicep](../test-petname.bicep) to verify:
- All word count options (1-4 words)
- Different separators (dash, underscore, dot, empty)
- Multiple seeds produce different outputs
- Exported functions work correctly
- Module outputs are consistent

The test file's `assert*` boolean outputs pin known seed→name pairs; run `./test.sh <resource-group>` to deploy it and fail on any false assertion.

For fast local/CI checks without a deployment, [tests/petname.assertions.bicep](../tests/petname.assertions.bicep) pins the same pairs as `assert` statements, evaluated by the experimental Bicep test framework: `bicep test tests/petname.tests.bicep` (run in CI by the Test workflow). When changing generation logic or word lists, both assertion sets must be deliberately regenerated in sync (they encode the backward-compatibility contract).

### Azure Integration Best Practices
- Use as imported module in other Bicep files
- Generate unique names with `utcNow()` seed for deployment-time randomness
- Use fixed seeds when reproducible names are required
- Consider adding suffix/prefix for resource type identification

## Key Files

- [petname.bicep](../petname.bicep) - Main module with word lists and generation logic
- [test-petname.bicep](../test-petname.bicep) - Comprehensive test scenarios and usage examples
- [README.md](../README.md) - Public documentation

## Common Usage Patterns

### As Module with Outputs
```bicep
module petname './petname.bicep' = {
  name: 'resourceName'
  params: {
    wordCount: 2
    separator: '-'
    seed: 12345
  }
}

output name string = petname.outputs.petName
```

### Using Exported Functions
```bicep
import * as petname from './petname.bicep'

output quickName string = petname.generateTwoWords('-', 99999)
```

### Dynamic Seeding for Uniqueness
```bicep
module uniqueName './petname.bicep' = {
  name: 'uniqueName'
  params: {
    seed: int(utcNow('yyyyMMddHHmmss'))
  }
}
```

## Maintenance Notes

- Word lists are static arrays - no runtime modification
- Limited to 1-4 words (enforced by `@minValue`/`@maxValue` on `wordCount`)
- Randomization is pseudo-random (seed mixing + modulo, not cryptographic)
- Apache 2.0 licensed - maintain copyright attribution
