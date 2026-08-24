/*
  Assertion harness for main.bicep, evaluated locally (no deployment) by
  the experimental Bicep test framework via tests/unit/namesmith.tests.bicep.

  These pin the seed -> name backward-compatibility contract: the same seed
  must always produce the same name. If a change to the generation logic or
  word lists breaks them, that break must be deliberate and the expected
  values regenerated. They mirror the assert* outputs in
  ../e2e/defaults/main.test.bicep.
*/

import * as namesmith from '../../main.bicep'

// One word per count
assert singleWord = namesmith.getName(99999) == 'bengal'
assert twoWord = namesmith.generateTwoWords('-', 88888) == 'uncommon-starfish'
assert threeWord = namesmith.generateThreeWords('-', 77777) == 'apparently-choice-monkey'
assert fourWord = namesmith.generateFourWords('-', 66666) == 'especially-heavily-first-pig'

// Negative seeds must yield valid indices, not crash (regression test)
assert negativeSeed = namesmith.getName(-42) == 'cougar'

// Separator variants
assert underscoreSeparator = namesmith.generateTwoWords('_', 67890) == 'renewing_doberman'
assert emptySeparator = namesmith.generateTwoWords('', 22222) == 'clevercamel'
assert dotSeparator = namesmith.generateThreeWords('.', 33333) == 'duly.upward.mastiff'
