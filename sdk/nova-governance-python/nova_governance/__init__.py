"""
NOVA Governance SDK — DAO Voting & Proposal Lifecycle

Copyright © 2024-2026 Alfredo Medina Hernandez
Medina Tech | Dallas, Texas, USA
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
"""
__version__ = "1.0.0"
__build__ = 68

from .constants import PHI, PHI_INV, ProposalState, VoteChoice, GovernanceRole, QuorumType
from .proposal import Proposal, ProposalEngine
from .voting import VotingEngine, Vote, VoteResult
from .quorum import QuorumCalculator, QuorumResult
from .council import Council, CouncilMember

__all__ = [
    "__version__", "__build__",
    "PHI", "PHI_INV", "ProposalState", "VoteChoice", "GovernanceRole", "QuorumType",
    "Proposal", "ProposalEngine",
    "VotingEngine", "Vote", "VoteResult",
    "QuorumCalculator", "QuorumResult",
    "Council", "CouncilMember",
]
