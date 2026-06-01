# NOVA Token SDK — Python Internal SDK

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**  
**CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA**

## Overview

Token economics — forge, ledger, staking, φ-bonding curves. Pure Python 3.9+, zero external dependencies.

## Installation

```bash
pip install -e sdk/nova-token-python/
```

## Quick Start

```python
from nova_token import *
```

## Modules

| Module | Description |
|--------|-------------|
| `constants` | Token states, stake states, curve types |
| `token` | Token ledger (mint/transfer/burn) |
| `forge` | Token creation & minting |
| `staking` | φ-weighted staking pool |
| `bonding` | φ-bonding price curves |

## Running Tests

```bash
cd sdk/nova-token-python
python -m pytest tests/ -v
# Or directly:
python tests/test_*.py
```

## Dependencies

**None.** Pure Python 3.9+ standard library only.
