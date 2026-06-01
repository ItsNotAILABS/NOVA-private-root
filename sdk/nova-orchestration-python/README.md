# NOVA Orchestration SDK — Python Internal SDK

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**  
**CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA**

## Overview

Agent & task orchestration — pipelines, scheduling, fleet coordination. Pure Python 3.9+, zero external dependencies.

## Installation

```bash
pip install -e sdk/nova-orchestration-python/
```

## Quick Start

```python
from nova_orchestration import *
```

## Modules

| Module | Description |
|--------|-------------|
| `constants` | Task states, agent roles, priorities |
| `task` | Priority task queue with dependencies |
| `agent` | Agent pool with φ-weighted assignment |
| `pipeline` | Sequential pipeline execution |
| `scheduler` | φ-interval scheduler |

## Running Tests

```bash
cd sdk/nova-orchestration-python
python -m pytest tests/ -v
# Or directly:
python tests/test_*.py
```

## Dependencies

**None.** Pure Python 3.9+ standard library only.
