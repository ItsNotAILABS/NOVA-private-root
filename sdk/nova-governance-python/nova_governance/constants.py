"""NOVA Governance — Constants"""
from enum import Enum
PHI = 1.6180339887498948482
PHI_INV = 0.6180339887498948482

class ProposalState(str, Enum):
    DRAFT = "DRAFT"
    ACTIVE = "ACTIVE"
    PASSED = "PASSED"
    REJECTED = "REJECTED"
    EXECUTED = "EXECUTED"
    EXPIRED = "EXPIRED"

class VoteChoice(str, Enum):
    FOR = "FOR"
    AGAINST = "AGAINST"
    ABSTAIN = "ABSTAIN"

class GovernanceRole(str, Enum):
    CITIZEN = "CITIZEN"
    DELEGATE = "DELEGATE"
    COUNCILOR = "COUNCILOR"
    SOVEREIGN = "SOVEREIGN"

class QuorumType(str, Enum):
    SIMPLE_MAJORITY = "SIMPLE_MAJORITY"
    SUPER_MAJORITY = "SUPER_MAJORITY"
    PHI_WEIGHTED = "PHI_WEIGHTED"
    UNANIMOUS = "UNANIMOUS"
