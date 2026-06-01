# NOVA Synapse SDK — Python Internal SDK

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**  
**CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA**

## Overview

Neural connections — signal propagation, Hebbian learning. Pure Python 3.9+, zero external dependencies.

## Installation

```bash
pip install -e sdk/nova-synapse-python/
```

## Quick Start

```python
from nova_synapse import *
```

## Modules

| Module | Description |
|--------|-------------|
| `constants` | Synapse types, signal types, plasticity modes |
| `synapse` | Synapse network with φ-weights |
| `signal` | Signal propagation engine |
| `hebbian` | Hebbian/STDP learning |
| `topology` | Network topology analysis |

## Running Tests

```bash
cd sdk/nova-synapse-python
python -m pytest tests/ -v
# Or directly:
python tests/test_*.py
```

## Dependencies

**None.** Pure Python 3.9+ standard library only.
