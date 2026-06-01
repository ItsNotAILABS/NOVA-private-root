"""NOVA Consensus — Constants"""
from enum import Enum
PHI = 1.6180339887498948482
PHI_INV = 0.6180339887498948482
BFT_THRESHOLD = 2/3  # Byzantine fault tolerance

class NodeRole(str, Enum):
    LEADER = "LEADER"
    VALIDATOR = "VALIDATOR"
    OBSERVER = "OBSERVER"
    CANDIDATE = "CANDIDATE"

class ConsensusPhase(str, Enum):
    IDLE = "IDLE"
    PRE_PREPARE = "PRE_PREPARE"
    PREPARE = "PREPARE"
    COMMIT = "COMMIT"
    FINALIZED = "FINALIZED"

class BlockState(str, Enum):
    PROPOSED = "PROPOSED"
    VALIDATED = "VALIDATED"
    COMMITTED = "COMMITTED"
    FINALIZED = "FINALIZED"
    REJECTED = "REJECTED"

class VoteType(str, Enum):
    PRE_VOTE = "PRE_VOTE"
    VOTE = "VOTE"
    COMMIT = "COMMIT"
