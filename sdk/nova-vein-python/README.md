# NOVA Vein SDK — Python Internal SDK

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**  
**CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA**

## Overview

Data flow & nutrient transport — φ-pressure routing. Pure Python 3.9+, zero external dependencies.

## Installation

```bash
pip install -e sdk/nova-vein-python/
```

## Quick Start

```python
from nova_vein import *
```

## Modules

| Module | Description |
|--------|-------------|
| `constants` | Flow states, vein types, pressure levels |
| `vein` | Vein network with BFS routing |
| `flow` | Packet flow engine |
| `pressure` | Pressure regulation |
| `nutrient` | Computational nutrient transport |

## Running Tests

```bash
cd sdk/nova-vein-python
python -m pytest tests/ -v
# Or directly:
python tests/test_*.py
```

## Dependencies

**None.** Pure Python 3.9+ standard library only.
