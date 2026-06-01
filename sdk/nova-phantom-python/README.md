# NOVA Phantom SDK — Python Internal SDK

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**  
**CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA**

## Overview

Phantom transfer — envelope encryption, stealth addressing, key management. Pure Python 3.9+, zero external dependencies.

## Installation

```bash
pip install -e sdk/nova-phantom-python/
```

## Quick Start

```python
from nova_phantom import *
```

## Modules

| Module | Description |
|--------|-------------|
| `constants` | Envelope states, key types, transfer states |
| `envelope` | Phantom envelope seal/deliver |
| `stealth` | One-time stealth address generation |
| `transfer` | Private transfer execution |
| `keys` | Cryptographic key management |

## Running Tests

```bash
cd sdk/nova-phantom-python
python -m pytest tests/ -v
# Or directly:
python tests/test_*.py
```

## Dependencies

**None.** Pure Python 3.9+ standard library only.
