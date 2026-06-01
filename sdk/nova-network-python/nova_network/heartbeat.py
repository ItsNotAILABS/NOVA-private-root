"""
NOVA Network SDK — Heartbeat / Timing Synchronization

Copyright © 2024-2026 Alfredo Medina Hernandez
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA

The HEARTBEAT protocol provides timing synchronization across the organism.
The 873ms period is derived from φ⁴ × Schumann resonance period.

Mathematical Foundation:
  - φ = 1.6180339887498948482 (Golden Ratio)
  - φ⁴ ≈ 6.854
  - Schumann fundamental frequency ≈ 7.83 Hz
  - HEARTBEAT = φ⁴ × (1000/7.83) ≈ 873ms
"""

import time
import threading
from typing import Callable, List, Dict, Optional
from dataclasses import dataclass, field

from .constants import (
    PHI, PHI_INV, HEARTBEAT_MS, BeatType, RhythmState,
)


@dataclass
class Beat:
    """A single heartbeat pulse."""
    beat_id: str
    sequence: int
    beat_type: BeatType
    timestamp: float
    scheduled_time: Optional[float] = None
    actual_time: Optional[float] = None
    drift: float = 0.0

    def execute(self) -> "Beat":
        """Record actual execution time and compute drift."""
        self.actual_time = time.time() * 1000
        if self.scheduled_time:
            self.drift = self.actual_time - self.scheduled_time
        return self


class HeartbeatEngine:
    """
    φ-synchronized heartbeat engine for NOVA timing coordination.

    Generates beats at 873ms intervals (φ⁴ × Schumann period).
    Monitors rhythm health and detects arrhythmia.
    """

    def __init__(self, node_id: str = "UNKNOWN"):
        """
        Args:
            node_id: The node ID this heartbeat belongs to
        """
        self._node_id = node_id
        self._sequence: int = 0
        self._running: bool = False
        self._timer: Optional[threading.Timer] = None
        self._rhythm: RhythmState = RhythmState.ASYSTOLE
        self._listeners: List[Callable] = []
        self._history: List[Beat] = []
        self._last_beat_time: float = 0.0
        self._drift_sum: float = 0.0
        self._beat_count: int = 0

    def start(self) -> "HeartbeatEngine":
        """Start the heartbeat."""
        if self._running:
            return self
        self._running = True
        self._rhythm = RhythmState.NORMAL
        self._schedule_next()
        return self

    def stop(self) -> "HeartbeatEngine":
        """Stop the heartbeat."""
        self._running = False
        if self._timer:
            self._timer.cancel()
            self._timer = None
        self._rhythm = RhythmState.ASYSTOLE
        return self

    def beat_once(self) -> Beat:
        """Generate a single beat synchronously (no timer)."""
        self._sequence += 1
        beat_type = BeatType.SYSTOLE if self._sequence % 2 == 1 else BeatType.DIASTOLE
        beat = Beat(
            beat_id=f"beat_{self._sequence}_{int(time.time()*1000)}",
            sequence=self._sequence,
            beat_type=beat_type,
            timestamp=time.time() * 1000,
        )
        beat.execute()
        self._record_beat(beat)
        return beat

    def add_listener(self, fn: Callable) -> "HeartbeatEngine":
        """Add a beat listener callback."""
        self._listeners.append(fn)
        return self

    @property
    def rhythm(self) -> RhythmState:
        return self._rhythm

    @property
    def sequence(self) -> int:
        return self._sequence

    @property
    def average_drift(self) -> float:
        """Average timing drift in ms."""
        if self._beat_count == 0:
            return 0.0
        return round(self._drift_sum / self._beat_count, 2)

    def status(self) -> Dict:
        """Get heartbeat status."""
        return {
            "nodeId": self._node_id,
            "running": self._running,
            "rhythm": self._rhythm.value,
            "sequence": self._sequence,
            "intervalMs": HEARTBEAT_MS,
            "averageDrift": self.average_drift,
            "lastBeat": self._history[-1].beat_id if self._history else None,
        }

    def _schedule_next(self):
        """Schedule the next heartbeat."""
        if not self._running:
            return
        self._timer = threading.Timer(HEARTBEAT_MS / 1000.0, self._on_beat)
        self._timer.daemon = True
        self._timer.start()

    def _on_beat(self):
        """Internal beat handler."""
        if not self._running:
            return
        beat = self.beat_once()
        for fn in self._listeners:
            try:
                fn(beat)
            except Exception:
                pass
        self._schedule_next()

    def _record_beat(self, beat: Beat):
        """Record a beat and update rhythm analysis."""
        now = beat.actual_time or beat.timestamp
        if self._last_beat_time > 0:
            interval = now - self._last_beat_time
            drift = interval - HEARTBEAT_MS
            self._drift_sum += abs(drift)
            self._beat_count += 1
            # Rhythm detection
            if abs(drift) > HEARTBEAT_MS * 0.5:
                self._rhythm = RhythmState.ARRHYTHMIA
            elif interval < HEARTBEAT_MS * PHI_INV:
                self._rhythm = RhythmState.TACHYCARDIA
            elif interval > HEARTBEAT_MS * PHI:
                self._rhythm = RhythmState.BRADYCARDIA
            else:
                self._rhythm = RhythmState.NORMAL

        self._last_beat_time = now
        self._history.append(beat)
        if len(self._history) > 100:
            self._history.pop(0)
