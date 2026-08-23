/*
  Assertion harness for petname.bicep, evaluated locally (no deployment) by
  the experimental Bicep test framework via tests/petname.tests.bicep.

  These pin the seed -> name backward-compatibility contract: the same seed
  must always produce the same name. If a change to the generation logic or
  word lists breaks them, that break must be deliberate and the expected
  values regenerated. They mirror the assert* outputs in ../test-petname.bicep.
*/

import * as petname from '../petname.bicep'

// One word per count
assert singleWord = petname.getName(99999) == 'bengal'
assert twoWord = petname.generateTwoWords('-', 88888) == 'uncommon-starfish'
assert threeWord = petname.generateThreeWords('-', 77777) == 'apparently-choice-monkey'
assert fourWord = petname.generateFourWords('-', 66666) == 'especially-heavily-first-pig'

// Negative seeds must yield valid indices, not crash (regression test)
assert negativeSeed = petname.getName(-42) == 'cougar'

// Separator variants
assert underscoreSeparator = petname.generateTwoWords('_', 67890) == 'renewing_doberman'
assert emptySeparator = petname.generateTwoWords('', 22222) == 'clevercamel'
assert dotSeparator = petname.generateThreeWords('.', 33333) == 'duly.upward.mastiff'
