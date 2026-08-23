# Contributing

## Getting set up

You need the Azure CLI with the Bicep extension:

```bash
az bicep version
```

No Azure subscription is required for local development — only `./test.sh` (deployment-level
testing) needs one.

## Making a change

```bash
# Compile/validate the module (also validates the e2e test file, which imports it)
az bicep build --file tests/e2e/defaults/main.test.bicep

# Run the local assertion tests (no Azure needed)
az bicep run --command "test tests/unit/namesmith.tests.bicep"
```

If you have an Azure subscription and want to exercise the deployment-level suite:

```bash
./test.sh <resource-group>
```

## Rules for changes to `main.bicep`

- **Determinism is the contract.** The same seed must always produce the same name. If you
  change the seed-mixing scheme, word-selector offsets, or word lists, you are breaking that
  contract on purpose — regenerate the pinned seed→name pairs in both
  `tests/e2e/defaults/main.test.bicep`'s `assert*` outputs and `tests/unit/namesmith.assertions.bicep`'s
  `assert` statements. They must stay in sync with each other and with reality.
- **Word lists** (`adjectives`, `adverbs`, `names`) must stay simple, positive, and
  professional, and alphabetically ordered (within each word-length group in `names`). They're
  static — no runtime modification.
- Keep the Apache 2.0 license header at the top of `main.bicep`.

See [CLAUDE.md](CLAUDE.md) for the full architecture writeup, and
[docs/adr/](docs/adr/) for the reasoning behind the repo's file layout.
