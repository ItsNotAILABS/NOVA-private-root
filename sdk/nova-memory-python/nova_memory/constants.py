"""NOVA Memory — Constants"""
from enum import Enum
PHI = 1.6180339887498948482
PHI_INV = 0.6180339887498948482
AMOR = 0.3819660112501051518

class MemoryTier(str, Enum):
    SENSORY = "SENSORY"       # <1s, raw input buffer
    WORKING = "WORKING"       # seconds, active processing
    SHORT_TERM = "SHORT_TERM" # minutes, recent context
    LONG_TERM = "LONG_TERM"   # persistent, consolidated
    SOVEREIGN = "SOVEREIGN"   # immutable, identity-core

class MemoryState(str, Enum):
    ACTIVE = "ACTIVE"
    CONSOLIDATING = "CONSOLIDATING"
    ARCHIVED = "ARCHIVED"
    DECAYED = "DECAYED"
    PROTECTED = "PROTECTED"

class ConsolidationMode(str, Enum):
    HEBBIAN = "HEBBIAN"       # strengthen on recall
    SLEEP = "SLEEP"           # offline consolidation
    PHI_WEIGHT = "PHI_WEIGHT" # φ-weighted importance
    EMERGENCY = "EMERGENCY"   # immediate consolidation
