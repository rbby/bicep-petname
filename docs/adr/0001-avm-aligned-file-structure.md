# Adopt an AVM-aligned file structure, keep module identity name

## Status

Accepted

## Context

"Industry standard folder structure" is ambiguous for a Bicep registry module. The closest
named convention for this specific artifact type is Microsoft's Azure Verified Modules (AVM)
layout — confirmed against a real published AVM module
(`Azure/bicep-registry-modules/avm/res/network/virtual-network`): `main.bicep` at root,
`tests/e2e/<scenario>/main.test.bicep`, a committed `main.json`, and `version.json` for
pipeline-driven versioning.

## Decision

Adopt the AVM `tests/e2e/<scenario>/main.test.bicep` layout, with three deliberate deviations:

- ~~Keep the entry file named `namesmith.bicep` rather than renaming to `main.bicep`. AVM's
  filename rule exists so Microsoft's AVM index/tooling can locate modules programmatically;
  this module isn't in that index, and the name carries the module's domain identity.~~
  **Superseded by [ADR-0002](0002-rename-main-bicep.md)**: the entry file is now `main.bicep`.
  The other two deviations below still stand.
- Add a `tests/unit/` tier (this repo's existing local `bicep test` assertion harness)
  alongside AVM's `tests/e2e/`, since AVM itself has no slot for that framework.
- Skip AVM's `version.json` and committed `main.json`. Both are tied to AVM's own release
  tooling and compiled-artifact conventions, which this module doesn't use; adopting them
  would be a process change, not a structure change, and this restructuring is scoped to
  structure only — the manual `workflow_dispatch` version input is unchanged.

## Considered Options

- Generic OSS layout (`src/`, `tests/`, `docs/`, `examples/`) — rejected: not specific to
  Bicep modules and doesn't map cleanly onto a two-file module.
- Full strict AVM compliance (`main.bicep`, `version.json`, committed `main.json`,
  multi-scenario `tests/e2e/*`) — rejected: this module isn't published through the AVM
  index, so the parts of the convention that exist to serve that index (discovery, automated
  versioning, compiled artifacts) add maintenance cost with no corresponding benefit here.
  Multi-scenario `tests/e2e/` splitting was also rejected on its own merits: the word-count/
  separator variations already exercised together in one file aren't independent optional
  features the way, say, a network module's peering vs. non-peering configs are.

## Consequences

- Local commands changed: `bicep test tests/unit/namesmith.tests.bicep`,
  `./test.sh <resource-group>` (now deploys `tests/e2e/defaults/main.test.bicep`).
- `tests/bicepconfig.json` moved to `tests/unit/bicepconfig.json`, scoping its
  experimental-flag requirement precisely to the tier that needs it — `tests/e2e/` doesn't
  use the `bicep test` framework syntax at all.
