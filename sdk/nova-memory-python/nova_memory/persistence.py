"""NOVA Memory — Persistence Layer"""
import json
import time
import hashlib
from dataclasses import dataclass, field
from typing import Any, Dict, Optional
from .store import MemoryStore, Memory


@dataclass
class Snapshot:
    snapshot_id: str
    timestamp_ms: float
    memory_count: int
    data: Dict[str, Any]


class PersistenceLayer:
    """Serialization/deserialization of memory state."""

    def __init__(self, store: MemoryStore):
        self._store = store
        self._snapshots: list = []

    def snapshot(self) -> Snapshot:
        """Create a point-in-time snapshot."""
        data = {}
        for mid, mem in self._store._memories.items():
            data[mid] = {
                "content": str(mem.content),
                "tier": mem.tier.value,
                "state": mem.state.value,
                "strength": mem.strength,
                "created_ms": mem.created_ms,
                "access_count": mem.access_count,
                "tags": mem.tags,
            }
        sid = hashlib.sha256(f"snap{time.time()}".encode()).hexdigest()[:12]
        snap = Snapshot(
            snapshot_id=sid,
            timestamp_ms=time.time() * 1000,
            memory_count=len(data),
            data=data,
        )
        self._snapshots.append(snap)
        return snap

    def export_json(self) -> str:
        """Export memory store as JSON."""
        snap = self.snapshot()
        return json.dumps(snap.data, indent=2)

    @property
    def snapshot_count(self) -> int:
        return len(self._snapshots)
