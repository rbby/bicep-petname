/*
  Test file for petname.bicep
  Demonstrates various ways to use the petname module
*/

// Import the petname module
import * as petname from './petname.bicep'

// Test 1: Default configuration (2 words with dash separator)
module defaultPetname './petname.bicep' = {
  name: 'defaultPetname'
}

// Test 2: Single word name
module singleWord './petname.bicep' = {
  name: 'singleWord'
  params: {
    wordCount: 1
    seed: 12345
  }
}

// Test 3: Two word name with custom separator
module twoWordUnderscore './petname.bicep' = {
  name: 'twoWordUnderscore'
  params: {
    wordCount: 2
    separator: '_'
    seed: 67890
  }
}

// Test 4: Three word name
module threeWord './petname.bicep' = {
  name: 'threeWord'
  params: {
    wordCount: 3
    seed: 11111
  }
}

// Test 5: Four word name
module fourWord './petname.bicep' = {
  name: 'fourWord'
  params: {
    wordCount: 4
    seed: 44444
  }
}

// Test 6: Empty separator
module noSeparator './petname.bicep' = {
  name: 'noSeparator'
  params: {
    wordCount: 2
    separator: ''
    seed: 22222
  }
}

// Test 7: Dot separator for domain-style names
module dotSeparator './petname.bicep' = {
  name: 'dotSeparator'
  params: {
    wordCount: 3
    separator: '.'
    seed: 33333
  }
}

// Test using exported functions directly
output testFunctionsSingleWord string = petname.getName(99999)
output testFunctionsTwoWord string = petname.generateTwoWords('-', 88888)
output testFunctionsThreeWord string = petname.generateThreeWords('-', 77777)
output testFunctionsFourWord string = petname.generateFourWords('-', 66666)

// Regression assertions: known seed -> name pairs. Same seed must always
// produce the same name (backward compatibility guarantee). test.sh fails
// the run if any assert* output is false.
output assertSingleWord bool = petname.getName(99999) == 'bengal'
output assertTwoWord bool = petname.generateTwoWords('-', 88888) == 'uncommon-starfish'
output assertThreeWord bool = petname.generateThreeWords('-', 77777) == 'apparently-choice-monkey'
output assertFourWord bool = petname.generateFourWords('-', 66666) == 'especially-heavily-first-pig'
output assertNegativeSeed bool = petname.getName(-42) == 'cougar'
output assertModuleSingleWord bool = singleWord.outputs.petName == 'bobcat'
output assertModuleTwoWordSeparator bool = twoWordUnderscore.outputs.petName == 'renewing_doberman'
output assertModuleThreeWord bool = threeWord.outputs.petName == 'recently-flowing-vulture'
output assertModuleFourWord bool = fourWord.outputs.petName == 'sadly-thankfully-relative-lark'
output assertModuleNoSeparator bool = noSeparator.outputs.petName == 'clevercamel'
output assertModuleDotSeparator bool = dotSeparator.outputs.petName == 'duly.upward.mastiff'

// Output all test results
output defaultResult string = defaultPetname.outputs.petName
output singleWordResult string = singleWord.outputs.petName
output twoWordUnderscoreResult string = twoWordUnderscore.outputs.petName
output threeWordResult string = threeWord.outputs.petName
output fourWordResult string = fourWord.outputs.petName
output noSeparatorResult string = noSeparator.outputs.petName
output dotSeparatorResult string = dotSeparator.outputs.petName

// Output alternative formats from one module
output defaultSingleWord string = defaultPetname.outputs.singleWordName
output defaultTwoWord string = defaultPetname.outputs.twoWordName
output defaultThreeWord string = defaultPetname.outputs.threeWordName
output defaultFourWord string = defaultPetname.outputs.fourWordName

// Examples of using different seeds to generate multiple unique names
output petname1 string = petname.generateTwoWords('-', 1)
output petname2 string = petname.generateTwoWords('-', 2)
output petname3 string = petname.generateTwoWords('-', 3)
output petname4 string = petname.generateTwoWords('-', 4)
output petname5 string = petname.generateTwoWords('-', 5)
