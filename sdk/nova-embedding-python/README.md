# NOVA Embedding SDK — Python Internal SDK

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**  
**CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA**

## Overview

Vector embeddings — similarity search, φ-indexed retrieval. Pure Python 3.9+, zero external dependencies.

## Installation

```bash
pip install -e sdk/nova-embedding-python/
```

## Quick Start

```python
from nova_embedding import *
```

## Modules

| Module | Description |
|--------|-------------|
| `constants` | Distance metrics, embedding types |
| `vector` | In-memory vector store |
| `similarity` | Similarity computation engine |
| `reduction` | Random projection dimension reduction |
| `index` | φ-bucketed approximate nearest neighbor |

## Running Tests

```bash
cd sdk/nova-embedding-python
python -m pytest tests/ -v
# Or directly:
python tests/test_*.py
```

## Dependencies

**None.** Pure Python 3.9+ standard library only.
