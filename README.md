# bicep-petname

A pure Bicep module that generates human-readable, pseudo-random names for Azure resources (e.g. `bright-falcon`, `apparently-choice-monkey`). Inspired by the original **petname** utility from [Dustin Kirkland](https://github.com/dustinkirkland). No external dependencies.

AI did all the heavy lifting here.

## Usage

### As a module

```bicep
module petname './petname.bicep' = {
  name: 'petname'
  params: {
    wordCount: 2
    separator: '-'
    seed: 12345
  }
}

output name string = petname.outputs.petName
```

### Via imported functions

```bicep
import * as petname from './petname.bicep'

output quickName string = petname.generateTwoWords('-', 99999)
output longName string = petname.generateFourWords('-', 99999)
```

## Parameters

| Parameter   | Type   | Default                        | Description                                        |
| ----------- | ------ | ------------------------------ | -------------------------------------------------- |
| `wordCount` | int    | `2`                            | Number of words in the name (1–4)                  |
| `separator` | string | `'-'`                          | Separator between words (may be empty)             |
| `seed`      | int    | `int(utcNow('yyyyMMddHHmmss'))` | Seed for randomization; negative values are valid |

Word composition by count: 1 = name, 2 = adjective + name, 3 = adverb + adjective + name, 4 = adverb + adverb + adjective + name.

## Determinism

Generation is deterministic: the same seed always produces the same name, so fixed seeds give reproducible names and the default `utcNow`-based seed gives deployment-time uniqueness. To generate several distinct names in one deployment, pass different seeds. Randomization is pseudo-random (seed mixing + modulo), not cryptographic.

## Testing

Bicep outputs are only evaluated at deployment time, so tests run as a real deployment. `test-petname.bicep` exercises all word counts and separators and includes `assert*` outputs pinning known seed→name pairs (the backward-compatibility guarantee):

```bash
./test.sh <resource-group>
```

The script deploys the test file and fails if any assertion is false.

## Publishing

The [Publish Module](.github/workflows/publish-module.yaml) workflow (manual trigger) publishes the module to GitHub Container Registry as `br:ghcr.io/<owner>/bicep-petname:<version>`; the version is a required workflow input.

## License

Apache 2.0 — see [LICENSE](LICENSE).
