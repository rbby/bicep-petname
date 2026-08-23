# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A pure Bicep module that generates human-readable, pseudo-random names for Azure resources (e.g., `bright-falcon`, `happily-golden-eagle`). Inspired by Dustin Kirkland's petname utility. No external dependencies — the module itself lives in a single Bicep file (`main.bicep`); tests live under `tests/`.

The repo's file layout follows an AVM-aligned convention (Azure Verified Modules is the closest named standard for a Bicep registry module), with deliberate deviations — see [docs/adr/0001-avm-aligned-file-structure.md](docs/adr/0001-avm-aligned-file-structure.md) and [docs/adr/0002-rename-main-bicep.md](docs/adr/0002-rename-main-bicep.md).

## Commands

```bash
# Compile/validate the module (also validates the e2e test file, which imports it)
az bicep build --file tests/e2e/defaults/main.test.bicep

# Run the local assertion tests (no Azure needed; also run in CI by test.yaml).
# `az bicep` has no dedicated `test` wrapper; `run` forwards raw commands to
# the installed Bicep CLI.
az bicep run --command "test tests/unit/namesmith.tests.bicep"

# Run the deployment-level test suite: deploys tests/e2e/defaults/main.test.bicep
# and fails if any assert* output is false
./test.sh <resource-group>
```

The local tests use the experimental Bicep test framework; the flags enabling it live in `tests/unit/bicepconfig.json` and apply only to files under `tests/unit/` — never enable them in a root bicepconfig.json, or the published module builds pick them up.

Publishing to the GitHub Container Registry (`br:ghcr.io/<owner>/bicep-namesmith`) is done via the manually-triggered `publish-module.yaml` GitHub Actions workflow (`workflow_dispatch` only); the version is a required workflow input.

## Architecture

- **`main.bicep`** — the entire module: three static word-list arrays (`adjectives`, `adverbs`, `names`), a set of `@export()`-ed functions, and module outputs. Every exported function and output carries an `@description()` decorator (short, consumer-facing "what it does"); where a function's behavior needs a "why" — e.g. `getRandomIndex`'s seed-mixing scheme — that stays as a separate `//` comment above the decorator rather than folding into it. Usable two ways:
  1. As a module (`module x './main.bicep'` with `wordCount`, `separator`, `seed` params; read `outputs.name`)
  2. Via function import (`import * as namesmith from './main.bicep'`, then `namesmith.generateTwoWords('-', seed)`)
- **`tests/e2e/defaults/main.test.bicep`** — exercises both usage styles across word counts (1–4), separators, and seeds, and pins known seed→name pairs in `assert*` boolean outputs. Bicep outputs are only evaluated at deployment time, so `test.sh` deploys it and fails on any false assertion.
- **`tests/unit/`** — `namesmith.tests.bicep` + `namesmith.assertions.bicep`, the no-Azure-needed counterpart evaluated by the experimental Bicep test framework; mirrors the same seed→name pairs as `assert` statements.
- **`examples/`** — standalone, independently-buildable `.bicep` files demonstrating usage patterns beyond the README's inline snippets (currently: generating several distinct names for multiple resources in one deployment via per-resource seed offsets).
- **`CONTRIBUTING.md`** — human-facing front door restating the commands and constraints below; keep it in sync with this file when either changes.

### Generation logic

Randomization is deterministic: `getRandomIndex` normalizes the seed to non-negative (double modulo against prime 715827883 — negative seeds are valid) and mixes it with Knuth's multiplier 2654435761 before the final modulo, so consecutive seeds (e.g. `utcNow` timestamps) map to unrelated words. Word selectors offset the seed (+0 adverb, +1 adjective, +2 name, +3 second adverb) so one seed yields different words per position. The default seed is `int(utcNow('yyyyMMddHHmmss'))` for deployment-time uniqueness.

## Constraints

- **Preserve determinism and backward compatibility**: the same seed must always produce the same name. This contract is encoded twice — the `assert*` outputs in `tests/e2e/defaults/main.test.bicep` and the `assert` statements in `tests/unit/namesmith.assertions.bicep` (enforced in CI) — and the two must stay in sync. Changing the mixing/offset scheme or word lists breaks them and must be a deliberate decision, with both sets of expected values regenerated.
- **Word lists**: keep words simple, positive, and professional; maintain alphabetical order (within each word-length group in `names`); word lists are static — no runtime modification.
- Apache 2.0 licensed — keep the license header in `main.bicep`.
