# NOVA Health SDK — Python Internal SDK

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**  
**CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA**

## Overview

System health monitoring — diagnostics, anomaly detection, self-healing. Pure Python 3.9+, zero external dependencies.

## Installation

```bash
pip install -e sdk/nova-health-python/
```

## Quick Start

```python
from nova_health import *
```

## Modules

| Module | Description |
|--------|-------------|
| `constants` | Health states, severity levels, subsystems |
| `monitor` | System-wide health checks |
| `diagnostics` | Deep diagnostic suites |
| `anomaly` | Statistical anomaly detection |
| `healing` | Automated self-healing actions |

## Running Tests

```bash
cd sdk/nova-health-python
python -m pytest tests/ -v
# Or directly:
python tests/test_*.py
```

## Dependencies

**None.** Pure Python 3.9+ standard library only.
