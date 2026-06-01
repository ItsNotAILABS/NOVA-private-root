# NOVA Consensus SDK — Python Internal SDK

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**  
**CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA**

## Overview

Standalone φ-weighted BFT consensus — leader election, blockchain finality. Pure Python 3.9+, zero external dependencies.

## Installation

```bash
pip install -e sdk/nova-consensus-python/
```

## Quick Start

```python
from nova_consensus import *
```

## Modules

| Module | Description |
|--------|-------------|
| `constants` | Node roles, consensus phases, block states |
| `node` | Consensus node with term management |
| `block` | In-memory blockchain |
| `voting` | BFT voting with φ-weights |
| `leader` | Raft-like leader election |

## Running Tests

```bash
cd sdk/nova-consensus-python
python -m pytest tests/ -v
# Or directly:
python tests/test_*.py
```

## Dependencies

**None.** Pure Python 3.9+ standard library only.
