# NOVA Swarm SDK — Python Internal SDK

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**  
**CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA**

## Overview

Swarm intelligence — Boids coordination, Kuramoto sync, golden formations. Pure Python 3.9+, zero external dependencies.

## Installation

```bash
pip install -e sdk/nova-swarm-python/
```

## Quick Start

```python
from nova_swarm import *
```

## Modules

| Module | Description |
|--------|-------------|
| `constants` | Swarm roles, states, formation types |
| `agent` | Swarm agent pool |
| `coordinator` | φ-weighted Boids coordination |
| `kuramoto` | Phase synchronization model |
| `formation` | Golden spiral/Fibonacci lattice patterns |

## Running Tests

```bash
cd sdk/nova-swarm-python
python -m pytest tests/ -v
# Or directly:
python tests/test_*.py
```

## Dependencies

**None.** Pure Python 3.9+ standard library only.
