# NOVA Sovereignty SDK — Python Internal SDK

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**  
**CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA**

## Overview

Sovereignty Validation Authority — claim verification, certification. Pure Python 3.9+, zero external dependencies.

## Installation

```bash
pip install -e sdk/nova-sovereignty-python/
```

## Quick Start

```python
from nova_sovereignty import *
```

## Modules

| Module | Description |
|--------|-------------|
| `constants` | Claim types, cert states, evidence grades |
| `claims` | Claim registry & review |
| `validator` | DR-1 through DR-6 validation |
| `certificate` | Certificate issuance & verification |
| `evidence` | Evidence matrix scoring |

## Running Tests

```bash
cd sdk/nova-sovereignty-python
python -m pytest tests/ -v
# Or directly:
python tests/test_*.py
```

## Dependencies

**None.** Pure Python 3.9+ standard library only.
