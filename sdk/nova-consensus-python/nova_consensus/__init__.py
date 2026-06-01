"""
NOVA Consensus SDK — Standalone φ-Weighted BFT Consensus

Copyright © 2024-2026 Alfredo Medina Hernandez
Medina Tech | Dallas, Texas, USA
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
"""
__version__ = "1.0.0"
__build__ = 68

from .constants import PHI, PHI_INV, NodeRole, ConsensusPhase, BlockState, VoteType
from .node import ConsensusNode, NodeConfig
from .block import Block, BlockChain
from .voting import BFTVoting, BFTVote, BFTResult
from .leader import LeaderElection, ElectionResult

__all__ = [
    "__version__", "__build__",
    "PHI", "PHI_INV", "NodeRole", "ConsensusPhase", "BlockState", "VoteType",
    "ConsensusNode", "NodeConfig",
    "Block", "BlockChain",
    "BFTVoting", "BFTVote", "BFTResult",
    "LeaderElection", "ElectionResult",
]
