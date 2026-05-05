# Motoko Compilation Pipeline

This directory contains the Motoko compilation pipeline adapter for the Universal Compiler.

## Overview

Motoko compilation is already implemented via `scripts/nova` which drives `moc` (Motoko compiler) directly. This pipeline adapter integrates it into the Universal Compiler framework.

## Integration

The Universal Compiler calls `scripts/nova build` to compile all Motoko canisters.

## See Also

- `../../scripts/nova` — NOVA sovereign build CLI
- `../../src/` — Motoko canister source files (402 files, 55 canisters)
