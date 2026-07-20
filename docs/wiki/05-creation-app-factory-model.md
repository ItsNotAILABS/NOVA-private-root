# Creation and App Factory Model — NOVA CREATIO

NOVA CREATIO creates complete artifacts: apps, dashboards, browser extensions, documents, agent tools, capsule packages, and internal operating materials.

## Mission

Convert a prompt into a working asset with manifest, README, entrypoint, source files, tests, quality report, package plan, and receipt.

## Supported creation classes

- static web apps;
- dashboards;
- browser extensions;
- Node services;
- agent tools;
- documents and release notes;
- package manifests;
- deployment-candidate bundles.

## Required output contract

Every CREATIO app must include:

- `manifest.json`;
- `README.md`;
- runnable entrypoint;
- at least one validation test;
- quality gate report;
- package manifest before release.

## Anti-placeholder rule

A generated artifact is not accepted when it only describes what should be built. It must include real files, real run instructions, and a testable surface.

## Integration

CREATIO uses CORPUS for workspace/file state, MATHESIS for validation posture, CODEX for repo promotion, and PORT for release packaging.