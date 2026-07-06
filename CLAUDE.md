# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A pure Bicep module that generates human-readable, pseudo-random names for Azure resources (e.g., `bright-falcon`, `happily-golden-eagle`). Inspired by Dustin Kirkland's petname utility. No external dependencies — everything lives in two Bicep files.

## Commands

```bash
# Compile/validate the module (also validates the test file, which imports it)
az bicep build --file test-petname.bicep

# Run the local assertion tests (no Azure needed; also run in CI by test.yaml).
# `az bicep` does not expose the test subcommand, so call the binary directly.
~/.azure/bin/bicep test tests/petname.tests.bicep

# Run the deployment-level test suite: deploys test-petname.bicep and fails
# if any assert* output is false
./test.sh <resource-group>
```

The local tests use the experimental Bicep test framework; the flags enabling it live in `tests/bicepconfig.json` and apply only to files under `tests/` — never enable them in a root bicepconfig.json, or the published module builds pick them up.

Publishing to the GitHub Container Registry (`br:ghcr.io/<owner>/bicep-petname`) is done via the manually-triggered `publish-module.yaml` GitHub Actions workflow (`workflow_dispatch` only); the version is a required workflow input.

## Architecture

- **`petname.bicep`** — the entire module: three static word-list arrays (`adjectives`, `adverbs`, `names`), a set of `@export()`-ed functions, and module outputs. Usable two ways:
  1. As a module (`module x './petname.bicep'` with `wordCount`, `separator`, `seed` params; read `outputs.petName`)
  2. Via function import (`import * as petname from './petname.bicep'`, then `petname.generateTwoWords('-', seed)`)
- **`test-petname.bicep`** — exercises both usage styles across word counts (1–4), separators, and seeds, and pins known seed→name pairs in `assert*` boolean outputs. Bicep outputs are only evaluated at deployment time, so `test.sh` deploys it and fails on any false assertion.

### Generation logic

Randomization is deterministic: `getRandomIndex` normalizes the seed to non-negative (double modulo against prime 715827883 — negative seeds are valid) and mixes it with Knuth's multiplier 2654435761 before the final modulo, so consecutive seeds (e.g. `utcNow` timestamps) map to unrelated words. Word selectors offset the seed (+0 adverb, +1 adjective, +2 name, +3 second adverb) so one seed yields different words per position. The default seed is `int(utcNow('yyyyMMddHHmmss'))` for deployment-time uniqueness.

## Constraints (from .github/copilot-instructions.md)

- **Preserve determinism and backward compatibility**: the same seed must always produce the same name. This contract is encoded twice — the `assert*` outputs in `test-petname.bicep` and the `assert` statements in `tests/petname.assertions.bicep` (enforced in CI) — and the two must stay in sync. Changing the mixing/offset scheme or word lists breaks them and must be a deliberate decision, with both sets of expected values regenerated.
- **Word lists**: keep words simple, positive, and professional; maintain alphabetical order (within each word-length group in `names`); word lists are static — no runtime modification.
- Apache 2.0 licensed — keep the license header in `petname.bicep`.
