# NOVA Memory SDK — Python Internal SDK

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**  
**CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA**

## Overview

Sovereign Memory (Memoria) — φ-weighted persistence, consolidation, recall. Pure Python 3.9+, zero external dependencies.

## Installation

```bash
pip install -e sdk/nova-memory-python/
```

## Quick Start

```python
from nova_memory import *
```

## Modules

| Module | Description |
|--------|-------------|
| `constants` | Memory tiers, states, consolidation modes |
| `store` | φ-weighted memory store with decay |
| `consolidation` | Hebbian/sleep consolidation engine |
| `recall` | Associative & similarity recall |
| `persistence` | Snapshot serialization |

## Running Tests

```bash
cd sdk/nova-memory-python
python -m pytest tests/ -v
# Or directly:
python tests/test_*.py
```

## Dependencies

**None.** Pure Python 3.9+ standard library only.
