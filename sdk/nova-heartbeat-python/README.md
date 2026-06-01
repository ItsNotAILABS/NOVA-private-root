# NOVA Heartbeat SDK — Python Internal SDK

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**  
**CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA**

## Overview

873ms φ⁴-Schumann timing synchronization engine. Pure Python 3.9+, zero external dependencies.

## Installation

```bash
pip install -e sdk/nova-heartbeat-python/
```

## Quick Start

```python
from nova_heartbeat import *
```

## Modules

| Module | Description |
|--------|-------------|
| `constants` | φ constants, timing, enumerations |
| `engine` | Core 873ms heartbeat generator |
| `sync` | Kuramoto phase synchronization |
| `monitor` | Rhythm health monitoring |
| `scheduler` | Beat-aligned task scheduling |

## Running Tests

```bash
cd sdk/nova-heartbeat-python
python -m pytest tests/ -v
# Or directly:
python tests/test_*.py
```

## Dependencies

**None.** Pure Python 3.9+ standard library only.
