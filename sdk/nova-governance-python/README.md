# NOVA Governance SDK — Python Internal SDK

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**  
**CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA**

## Overview

DAO governance — proposal lifecycle, φ-weighted quorum voting. Pure Python 3.9+, zero external dependencies.

## Installation

```bash
pip install -e sdk/nova-governance-python/
```

## Quick Start

```python
from nova_governance import *
```

## Modules

| Module | Description |
|--------|-------------|
| `constants` | Proposal states, vote choices, governance roles |
| `proposal` | Proposal creation & lifecycle |
| `voting` | φ-weighted voting engine |
| `quorum` | Quorum calculation (simple/super/φ) |
| `council` | Governance council management |

## Running Tests

```bash
cd sdk/nova-governance-python
python -m pytest tests/ -v
# Or directly:
python tests/test_*.py
```

## Dependencies

**None.** Pure Python 3.9+ standard library only.
