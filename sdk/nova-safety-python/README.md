# NOVA Safety SDK — Python Internal SDK

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**  
**CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA**

## Overview

Alpha Safety protocol — 481 compliance controls enforcement. Pure Python 3.9+, zero external dependencies.

## Installation

```bash
pip install -e sdk/nova-safety-python/
```

## Quick Start

```python
from nova_safety import *
```

## Modules

| Module | Description |
|--------|-------------|
| `constants` | Safety levels, categories, 481 controls |
| `validator` | Action validation against safety rules |
| `compliance` | 481-control compliance engine |
| `threat` | Threat detection & classification |
| `constraints` | Constraint enforcement engine |

## Running Tests

```bash
cd sdk/nova-safety-python
python -m pytest tests/ -v
# Or directly:
python tests/test_*.py
```

## Dependencies

**None.** Pure Python 3.9+ standard library only.
