# NOVA Trust SDK — Python Internal SDK

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**  
**CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA**

## Overview

Trust & reputation protocol — φ-decay scoring, peer attestation. Pure Python 3.9+, zero external dependencies.

## Installation

```bash
pip install -e sdk/nova-trust-python/
```

## Quick Start

```python
from nova_trust import *
```

## Modules

| Module | Description |
|--------|-------------|
| `constants` | Trust levels, attestation types, decay modes |
| `score` | φ-weighted trust scoring |
| `attestation` | Peer attestation registry |
| `reputation` | Global reputation rankings |
| `decay` | Time-based trust decay engine |

## Running Tests

```bash
cd sdk/nova-trust-python
python -m pytest tests/ -v
# Or directly:
python tests/test_*.py
```

## Dependencies

**None.** Pure Python 3.9+ standard library only.
