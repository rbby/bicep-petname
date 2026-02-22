/*
  Test file for petname.bicep
  Demonstrates various ways to use the petname module
*/

// Import the petname module
import * as petname from '../src/petname.bicep'

// Test 1: Default configuration (2 words with dash separator)
module defaultPetname '../src/petname.bicep' = {
  name: 'defaultPetname'
}

// Test 2: Single word name
module singleWord '../src/petname.bicep' = {
  name: 'singleWord'
  params: {
    wordCount: 1
    seed: 12345
  }
}

// Test 3: Two word name with custom separator
module twoWordUnderscore '../src/petname.bicep' = {
  name: 'twoWordUnderscore'
  params: {
    wordCount: 2
    separator: '_'
    seed: 67890
  }
}

// Test 4: Three word name
module threeWord '../src/petname.bicep' = {
  name: 'threeWord'
  params: {
    wordCount: 3
    seed: 11111
  }
}

// Test 5: Empty separator
module noSeparator '../src/petname.bicep' = {
  name: 'noSeparator'
  params: {
    wordCount: 2
    separator: ''
    seed: 22222
  }
}

// Test 6: Dot separator for domain-style names
module dotSeparator '../src/petname.bicep' = {
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

// Output all test results
output defaultResult string = defaultPetname.outputs.petName
output singleWordResult string = singleWord.outputs.petName
output twoWordUnderscoreResult string = twoWordUnderscore.outputs.petName
output threeWordResult string = threeWord.outputs.petName
output noSeparatorResult string = noSeparator.outputs.petName
output dotSeparatorResult string = dotSeparator.outputs.petName

// Output alternative formats from one module
output defaultSingleWord string = defaultPetname.outputs.singleWordName
output defaultTwoWord string = defaultPetname.outputs.twoWordName
output defaultThreeWord string = defaultPetname.outputs.threeWordName

// Examples of using different seeds to generate multiple unique names
output petname1 string = petname.generateTwoWords('-', 1)
output petname2 string = petname.generateTwoWords('-', 2)
output petname3 string = petname.generateTwoWords('-', 3)
output petname4 string = petname.generateTwoWords('-', 4)
output petname5 string = petname.generateTwoWords('-', 5)
