"""NOVA Health — Constants"""
from enum import Enum
PHI = 1.6180339887498948482
PHI_INV = 0.6180339887498948482

class HealthState(str, Enum):
    HEALTHY = "HEALTHY"
    DEGRADED = "DEGRADED"
    UNHEALTHY = "UNHEALTHY"
    CRITICAL = "CRITICAL"
    DEAD = "DEAD"

class Severity(str, Enum):
    INFO = "INFO"
    LOW = "LOW"
    MEDIUM = "MEDIUM"
    HIGH = "HIGH"
    CRITICAL = "CRITICAL"

class SubsystemType(str, Enum):
    NETWORK = "NETWORK"
    MEMORY = "MEMORY"
    CONSENSUS = "CONSENSUS"
    HEARTBEAT = "HEARTBEAT"
    SAFETY = "SAFETY"
    TRUST = "TRUST"
    GOVERNANCE = "GOVERNANCE"
    SWARM = "SWARM"
