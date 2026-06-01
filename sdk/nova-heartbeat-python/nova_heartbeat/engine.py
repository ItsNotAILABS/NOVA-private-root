"""NOVA Heartbeat — Core Engine"""

import time
import math
from dataclasses import dataclass, field
from typing import List, Optional, Callable
from .constants import *


@dataclass
class HeartbeatConfig:
    """Configuration for the heartbeat engine."""
    interval_ms: float = HEARTBEAT_MS
    drift_tolerance_ms: float = 50.0
    phase_correction_rate: float = PHI_INV
    max_missed_beats: int = 5
    systole_ratio: float = PHI_INV  # systole takes φ⁻¹ of cycle


@dataclass
class Beat:
    """A single heartbeat pulse."""
    sequence: int
    beat_type: BeatType
    timestamp_ms: float
    interval_ms: float
    drift_ms: float
    phase: float  # 0..2π
    energy: float  # 0..1
    rhythm_state: RhythmState


class HeartbeatEngine:
    """
    The NOVA 873ms heartbeat engine.
    
    Generates φ⁴-Schumann-synchronized pulses with phase tracking,
    drift correction, and rhythm state classification.
    """

    def __init__(self, node_id: str = "default", config: Optional[HeartbeatConfig] = None):
        self.node_id = node_id
        self.config = config or HeartbeatConfig()
        self._sequence = 0
        self._last_beat_ms = 0.0
        self._phase = 0.0
        self._energy = 1.0
        self._missed = 0
        self._history: List[Beat] = []
        self._listeners: List[Callable] = []

    @property
    def sequence(self) -> int:
        return self._sequence

    @property
    def phase(self) -> float:
        return self._phase

    @property
    def energy(self) -> float:
        return self._energy

    @property
    def is_alive(self) -> bool:
        return self._missed < self.config.max_missed_beats

    def beat_once(self) -> Beat:
        """Generate a single heartbeat."""
        now = time.time() * 1000
        interval = now - self._last_beat_ms if self._last_beat_ms > 0 else self.config.interval_ms
        drift = interval - self.config.interval_ms if self._last_beat_ms > 0 else 0.0

        # Phase advancement: 2π per cycle
        self._phase = (self._phase + 2 * math.pi) % (2 * math.pi)

        # Energy decays toward PHI_INV, rebounds on beat
        self._energy = min(1.0, self._energy * PHI_INV + AMOR)

        # Determine beat type
        cycle_pos = (self._sequence % 3)
        if cycle_pos == 0:
            beat_type = BeatType.SYSTOLE
        elif cycle_pos == 1:
            beat_type = BeatType.DIASTOLE
        else:
            beat_type = BeatType.SYNC

        # Classify rhythm
        rhythm = self._classify_rhythm(interval)

        self._sequence += 1
        self._last_beat_ms = now

        beat = Beat(
            sequence=self._sequence,
            beat_type=beat_type,
            timestamp_ms=now,
            interval_ms=interval,
            drift_ms=drift,
            phase=self._phase,
            energy=self._energy,
            rhythm_state=rhythm,
        )
        self._history.append(beat)
        if len(self._history) > 100:
            self._history = self._history[-100:]

        for listener in self._listeners:
            listener(beat)

        return beat

    def _classify_rhythm(self, interval_ms: float) -> RhythmState:
        """Classify current rhythm based on interval."""
        if interval_ms < self.config.interval_ms * 0.7:
            return RhythmState.TACHYCARDIA
        elif interval_ms > self.config.interval_ms * 1.5:
            return RhythmState.BRADYCARDIA
        elif abs(interval_ms - self.config.interval_ms) > self.config.drift_tolerance_ms * 3:
            return RhythmState.ARRHYTHMIA
        else:
            return RhythmState.NORMAL

    def on_beat(self, listener: Callable) -> None:
        """Register a beat listener."""
        self._listeners.append(listener)

    def reset(self) -> None:
        """Reset engine state."""
        self._sequence = 0
        self._last_beat_ms = 0.0
        self._phase = 0.0
        self._energy = 1.0
        self._missed = 0
        self._history.clear()

    def history(self, n: int = 10) -> List[Beat]:
        """Get last n beats."""
        return self._history[-n:]
