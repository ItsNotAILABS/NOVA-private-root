# NOVA AI Bridge SDK — Python Internal SDK

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**  
**CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA**

## Overview

AI model gateway — inference routing, multi-model ensemble. Pure Python 3.9+, zero external dependencies.

## Installation

```bash
pip install -e sdk/nova-ai-bridge-python/
```

## Quick Start

```python
from nova_ai_bridge import *
```

## Modules

| Module | Description |
|--------|-------------|
| `constants` | Model types, inference states, routing strategies |
| `model` | Model registry with capabilities |
| `router` | φ-weighted inference routing |
| `gateway` | Centralized inference gateway |
| `ensemble` | Multi-model consensus engine |

## Running Tests

```bash
cd sdk/nova-ai-bridge-python
python -m pytest tests/ -v
# Or directly:
python tests/test_*.py
```

## Dependencies

**None.** Pure Python 3.9+ standard library only.
