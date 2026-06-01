"""NOVA Heartbeat — Rhythm Monitor"""

from dataclasses import dataclass, field
from typing import List, Optional
from .constants import RhythmState, HEARTBEAT_MS, PHI_INV
from .engine import Beat


@dataclass
class RhythmReport:
    """Summary of rhythm health over a window."""
    total_beats: int
    normal_beats: int
    abnormal_beats: int
    avg_interval_ms: float
    max_drift_ms: float
    rhythm_state: RhythmState
    coherence: float
    stability_score: float  # 0..1


class RhythmMonitor:
    """
    Monitors heartbeat rhythm over time and produces health reports.
    Detects arrhythmias, bradycardia, tachycardia, and asystole.
    """

    def __init__(self, window_size: int = 20):
        self.window_size = window_size
        self._beats: List[Beat] = []
        self._alerts: List[str] = []

    def record(self, beat: Beat) -> Optional[str]:
        """Record a beat and return alert if abnormal."""
        self._beats.append(beat)
        if len(self._beats) > self.window_size * 2:
            self._beats = self._beats[-self.window_size:]

        if beat.rhythm_state != RhythmState.NORMAL:
            alert = f"ALERT: {beat.rhythm_state.value} at beat #{beat.sequence}"
            self._alerts.append(alert)
            return alert
        return None

    def report(self) -> RhythmReport:
        """Generate a rhythm health report."""
        window = self._beats[-self.window_size:]
        if not window:
            return RhythmReport(0, 0, 0, 0.0, 0.0, RhythmState.ASYSTOLE, 0.0, 0.0)

        normal = sum(1 for b in window if b.rhythm_state == RhythmState.NORMAL)
        abnormal = len(window) - normal
        avg_interval = sum(b.interval_ms for b in window) / len(window)
        max_drift = max(abs(b.drift_ms) for b in window)

        # Determine overall state
        if abnormal == 0:
            state = RhythmState.NORMAL
        elif abnormal > len(window) * 0.5:
            state = RhythmState.ARRHYTHMIA
        else:
            state = window[-1].rhythm_state

        stability = normal / len(window) if window else 0.0
        coherence = 1.0 - (max_drift / HEARTBEAT_MS) if max_drift < HEARTBEAT_MS else 0.0

        return RhythmReport(
            total_beats=len(window),
            normal_beats=normal,
            abnormal_beats=abnormal,
            avg_interval_ms=avg_interval,
            max_drift_ms=max_drift,
            rhythm_state=state,
            coherence=max(0.0, coherence),
            stability_score=stability,
        )

    @property
    def alerts(self) -> List[str]:
        return list(self._alerts)

    def clear_alerts(self) -> None:
        self._alerts.clear()
