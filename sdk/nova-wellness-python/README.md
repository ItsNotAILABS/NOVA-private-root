# NOVA Wellness SDK — Python Internal SDK

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**  
**CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA**

## Overview

Organism wellness — vitality, sleep cycles, homeostasis, energy. Pure Python 3.9+, zero external dependencies.

## Installation

```bash
pip install -e sdk/nova-wellness-python/
```

## Quick Start

```python
from nova_wellness import *
```

## Modules

| Module | Description |
|--------|-------------|
| `constants` | Wellness states, vital signs, sleep phases |
| `vitality` | Multi-vital-sign monitoring |
| `sleep` | Sleep cycle engine (light/deep/REM) |
| `homeostasis` | PI-control homeostasis |
| `energy` | Energy pool management |

## Running Tests

```bash
cd sdk/nova-wellness-python
python -m pytest tests/ -v
# Or directly:
python tests/test_*.py
```

## Dependencies

**None.** Pure Python 3.9+ standard library only.
