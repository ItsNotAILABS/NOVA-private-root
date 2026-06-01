"""
NOVA Token SDK — Token Economics & Forge

Copyright © 2024-2026 Alfredo Medina Hernandez
Medina Tech | Dallas, Texas, USA
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
"""
__version__ = "1.0.0"
__build__ = 68

from .constants import PHI, PHI_INV, TokenState, StakeState, CurveType
from .token import Token, TokenLedger
from .forge import TokenForge, MintRecord
from .staking import StakingPool, Stake, StakeReward
from .bonding import BondingCurve, PricePoint

__all__ = [
    "__version__", "__build__",
    "PHI", "PHI_INV", "TokenState", "StakeState", "CurveType",
    "Token", "TokenLedger",
    "TokenForge", "MintRecord",
    "StakingPool", "Stake", "StakeReward",
    "BondingCurve", "PricePoint",
]
