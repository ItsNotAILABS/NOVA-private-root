# NOVA Solver SDK — Python Internal SDK

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**  
**CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA**

## Overview

Constraint & optimization — φ-gradient descent, golden section, annealing. Pure Python 3.9+, zero external dependencies.

## Installation

```bash
pip install -e sdk/nova-solver-python/
```

## Quick Start

```python
from nova_solver import *
```

## Modules

| Module | Description |
|--------|-------------|
| `constants` | Solver states, optimization methods |
| `optimizer` | Golden section & coordinate descent |
| `constraint_solver` | Constraint satisfaction |
| `gradient` | φ-scheduled gradient descent |
| `annealing` | Simulated annealing with φ-cooling |

## Running Tests

```bash
cd sdk/nova-solver-python
python -m pytest tests/ -v
# Or directly:
python tests/test_*.py
```

## Dependencies

**None.** Pure Python 3.9+ standard library only.
