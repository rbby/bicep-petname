# Rename the module entry file to `main.bicep`

## Status

Accepted

## Context

[ADR-0001](0001-avm-aligned-file-structure.md) deliberately kept the entry file named
`namesmith.bicep` instead of following AVM's `main.bicep` convention, reasoning that the
AVM filename rule serves module-index tooling this repo isn't part of, and that the name
carried useful domain identity. On reflection, full filename compliance with the "industry
standard" this repo already adopted for its folder layout was chosen instead.

## Decision

Rename `namesmith.bicep` to `main.bicep`, matching strict AVM convention. This supersedes
only that one bullet of ADR-0001; the `tests/unit/` addition and the decision to skip
`version.json`/committed `main.json` are unaffected.

## Consequences

- Every reference to the file path updates: `test.sh`'s target, both GitHub workflows
  (build, test, and publish steps), `README.md`, `CLAUDE.md`, `.github/copilot-instructions.md`,
  and the relative imports in `tests/unit/namesmith.assertions.bicep` and
  `tests/e2e/defaults/main.test.bicep`.
- Consumer-facing symbol names (the `module namesmith '...'` resource name and the
  `import * as namesmith` alias) are unchanged — those are chosen by the consuming Bicep
  file, not tied to the source filename, and still carry the module's domain identity.
