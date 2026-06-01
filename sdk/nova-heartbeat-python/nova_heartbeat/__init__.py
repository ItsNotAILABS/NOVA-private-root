"""
NOVA Heartbeat SDK — 873ms φ⁴-Schumann Timing Engine

Copyright © 2024-2026 Alfredo Medina Hernandez
Medina Tech | Dallas, Texas, USA
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
"""

__version__ = "1.0.0"
__build__ = 68

from .constants import (
    PHI, PHI_INV, AMOR, PHI_SQUARED, PHI_CUBED, PHI_FOURTH,
    SCHUMANN_FREQUENCY, SCHUMANN_PERIOD_MS, HEARTBEAT_MS,
    BeatType, RhythmState, PhaseState,
)
from .engine import HeartbeatEngine, Beat, HeartbeatConfig
from .sync import PhaseSynchronizer, PhaseVector
from .monitor import RhythmMonitor, RhythmReport
from .scheduler import HeartbeatScheduler, ScheduledTask

__all__ = [
    "__version__", "__build__",
    "PHI", "PHI_INV", "AMOR", "PHI_SQUARED", "PHI_CUBED", "PHI_FOURTH",
    "SCHUMANN_FREQUENCY", "SCHUMANN_PERIOD_MS", "HEARTBEAT_MS",
    "BeatType", "RhythmState", "PhaseState",
    "HeartbeatEngine", "Beat", "HeartbeatConfig",
    "PhaseSynchronizer", "PhaseVector",
    "RhythmMonitor", "RhythmReport",
    "HeartbeatScheduler", "ScheduledTask",
]
