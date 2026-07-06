# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A pure Bicep module that generates human-readable, pseudo-random names for Azure resources (e.g., `bright-falcon`, `happily-golden-eagle`). Inspired by Dustin Kirkland's petname utility. No external dependencies — everything lives in two Bicep files.

## Commands

There is no build system or test framework; validation is done with the Bicep CLI:

```bash
# Compile/validate the module (also validates the test file, which imports it)
az bicep build --file test-petname.bicep

# Or with the standalone Bicep CLI
bicep build test-petname.bicep

# Run the test suite: deploys test-petname.bicep and fails if any assert* output is false
./test.sh <resource-group>
```

Publishing to the GitHub Container Registry (`br:ghcr.io/<owner>/bicep-petname`) is done via the manually-triggered `publish-module.yaml` GitHub Actions workflow (`workflow_dispatch` only); the version is a required workflow input.

## Architecture

- **`petname.bicep`** — the entire module: three static word-list arrays (`adjectives`, `adverbs`, `names`), a set of `@export()`-ed functions, and module outputs. Usable two ways:
  1. As a module (`module x './petname.bicep'` with `wordCount`, `separator`, `seed` params; read `outputs.petName`)
  2. Via function import (`import * as petname from './petname.bicep'`, then `petname.generateTwoWords('-', seed)`)
- **`test-petname.bicep`** — exercises both usage styles across word counts (1–4), separators, and seeds, and pins known seed→name pairs in `assert*` boolean outputs. Bicep outputs are only evaluated at deployment time, so `test.sh` deploys it and fails on any false assertion.

### Generation logic

Randomization is deterministic: `getRandomIndex` normalizes the seed to non-negative (double modulo against prime 715827883 — negative seeds are valid) and mixes it with Knuth's multiplier 2654435761 before the final modulo, so consecutive seeds (e.g. `utcNow` timestamps) map to unrelated words. Word selectors offset the seed (+0 adverb, +1 adjective, +2 name, +3 second adverb) so one seed yields different words per position. The default seed is `int(utcNow('yyyyMMddHHmmss'))` for deployment-time uniqueness.

## Constraints (from .github/copilot-instructions.md)

- **Preserve determinism and backward compatibility**: the same seed must always produce the same name. The `assert*` outputs in `test-petname.bicep` encode this contract — changing the mixing/offset scheme or word lists breaks them and must be a deliberate decision (with assertions regenerated).
- **Word lists**: keep words simple, positive, and professional; maintain alphabetical order (within each word-length group in `names`); word lists are static — no runtime modification.
- Apache 2.0 licensed — keep the license header in `petname.bicep`.
