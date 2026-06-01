"""NOVA Vein — Flow Engine"""
import time
from dataclasses import dataclass, field
from typing import Any, Dict, List
from .constants import *
from .vein import VeinNetwork


@dataclass
class FlowPacket:
    packet_id: str
    source: str
    target: str
    payload: Any
    size: float = 1.0
    priority: int = 1
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)


@dataclass
class FlowStats:
    packets_delivered: int
    packets_dropped: int
    total_throughput: float
    avg_latency_ms: float
    congestion_events: int


class FlowEngine:
    """Manages data flow through the vein network."""

    def __init__(self, network: VeinNetwork):
        self._network = network
        self._delivered: List[FlowPacket] = []
        self._dropped: List[FlowPacket] = []
        self._congestion = 0
        self._counter = 0

    def send(self, source: str, target: str, payload: Any, size: float = 1.0) -> bool:
        self._counter += 1
        packet = FlowPacket(
            packet_id=f"PKT-{self._counter:06d}",
            source=source, target=target, payload=payload, size=size,
        )
        path = self._network.get_path(source, target)
        if not path:
            self._dropped.append(packet)
            return False

        # Check capacity
        for vein in path:
            if vein.current_load + size > vein.capacity:
                vein.state = FlowState.CONGESTED
                self._congestion += 1
                self._dropped.append(packet)
                return False
            vein.current_load += size
            vein.state = FlowState.FLOWING

        self._delivered.append(packet)
        return True

    def stats(self) -> FlowStats:
        return FlowStats(
            packets_delivered=len(self._delivered),
            packets_dropped=len(self._dropped),
            total_throughput=sum(p.size for p in self._delivered),
            avg_latency_ms=1.0,  # simulated
            congestion_events=self._congestion,
        )
