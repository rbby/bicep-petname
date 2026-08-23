/*
  Test file for namesmith.bicep
  Demonstrates various ways to use the namesmith module
*/

// Import the namesmith module
import * as namesmith from './namesmith.bicep'

// Test 1: Default configuration (2 words with dash separator)
module defaultName './namesmith.bicep' = {
  name: 'defaultName'
}

// Test 2: Single word name
module singleWord './namesmith.bicep' = {
  name: 'singleWord'
  params: {
    wordCount: 1
    seed: 12345
  }
}

// Test 3: Two word name with custom separator
module twoWordUnderscore './namesmith.bicep' = {
  name: 'twoWordUnderscore'
  params: {
    wordCount: 2
    separator: '_'
    seed: 67890
  }
}

// Test 4: Three word name
module threeWord './namesmith.bicep' = {
  name: 'threeWord'
  params: {
    wordCount: 3
    seed: 11111
  }
}

// Test 5: Four word name
module fourWord './namesmith.bicep' = {
  name: 'fourWord'
  params: {
    wordCount: 4
    seed: 44444
  }
}

// Test 6: Empty separator
module noSeparator './namesmith.bicep' = {
  name: 'noSeparator'
  params: {
    wordCount: 2
    separator: ''
    seed: 22222
  }
}

// Test 7: Dot separator for domain-style names
module dotSeparator './namesmith.bicep' = {
  name: 'dotSeparator'
  params: {
    wordCount: 3
    separator: '.'
    seed: 33333
  }
}

// Test using exported functions directly
output testFunctionsSingleWord string = namesmith.getName(99999)
output testFunctionsTwoWord string = namesmith.generateTwoWords('-', 88888)
output testFunctionsThreeWord string = namesmith.generateThreeWords('-', 77777)
output testFunctionsFourWord string = namesmith.generateFourWords('-', 66666)

// Regression assertions: known seed -> name pairs. Same seed must always
// produce the same name (backward compatibility guarantee). test.sh fails
// the run if any assert* output is false.
output assertSingleWord bool = namesmith.getName(99999) == 'bengal'
output assertTwoWord bool = namesmith.generateTwoWords('-', 88888) == 'uncommon-starfish'
output assertThreeWord bool = namesmith.generateThreeWords('-', 77777) == 'apparently-choice-monkey'
output assertFourWord bool = namesmith.generateFourWords('-', 66666) == 'especially-heavily-first-pig'
output assertNegativeSeed bool = namesmith.getName(-42) == 'cougar'
output assertModuleSingleWord bool = singleWord.outputs.name == 'bobcat'
output assertModuleTwoWordSeparator bool = twoWordUnderscore.outputs.name == 'renewing_doberman'
output assertModuleThreeWord bool = threeWord.outputs.name == 'recently-flowing-vulture'
output assertModuleFourWord bool = fourWord.outputs.name == 'sadly-thankfully-relative-lark'
output assertModuleNoSeparator bool = noSeparator.outputs.name == 'clevercamel'
output assertModuleDotSeparator bool = dotSeparator.outputs.name == 'duly.upward.mastiff'

// Output all test results
output defaultResult string = defaultName.outputs.name
output singleWordResult string = singleWord.outputs.name
output twoWordUnderscoreResult string = twoWordUnderscore.outputs.name
output threeWordResult string = threeWord.outputs.name
output fourWordResult string = fourWord.outputs.name
output noSeparatorResult string = noSeparator.outputs.name
output dotSeparatorResult string = dotSeparator.outputs.name

// Output alternative formats from one module
output defaultSingleWord string = defaultName.outputs.singleWordName
output defaultTwoWord string = defaultName.outputs.twoWordName
output defaultThreeWord string = defaultName.outputs.threeWordName
output defaultFourWord string = defaultName.outputs.fourWordName

// Examples of using different seeds to generate multiple unique names
output name1 string = namesmith.generateTwoWords('-', 1)
output name2 string = namesmith.generateTwoWords('-', 2)
output name3 string = namesmith.generateTwoWords('-', 3)
output name4 string = namesmith.generateTwoWords('-', 4)
output name5 string = namesmith.generateTwoWords('-', 5)
