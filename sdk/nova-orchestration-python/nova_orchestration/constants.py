"""NOVA Orchestration — Constants"""
from enum import Enum

PHI = 1.6180339887498948482
PHI_INV = 0.6180339887498948482

class TaskState(str, Enum):
    PENDING = "PENDING"
    RUNNING = "RUNNING"
    COMPLETED = "COMPLETED"
    FAILED = "FAILED"
    CANCELLED = "CANCELLED"
    RETRYING = "RETRYING"

class AgentRole(str, Enum):
    WORKER = "WORKER"
    COORDINATOR = "COORDINATOR"
    SUPERVISOR = "SUPERVISOR"
    SPECIALIST = "SPECIALIST"

class PipelineState(str, Enum):
    IDLE = "IDLE"
    RUNNING = "RUNNING"
    PAUSED = "PAUSED"
    COMPLETED = "COMPLETED"
    FAILED = "FAILED"

class Priority(int, Enum):
    LOW = 1
    NORMAL = 2
    HIGH = 3
    CRITICAL = 4
    SOVEREIGN = 5
