"""NOVA Governance — Quorum Calculator"""
from dataclasses import dataclass
from .constants import *


@dataclass
class QuorumResult:
    required: float
    actual: float
    met: bool
    quorum_type: QuorumType


class QuorumCalculator:
    """Calculates quorum requirements."""

    def check(self, total_eligible: int, total_voted: int,
              quorum_type: QuorumType = QuorumType.PHI_WEIGHTED) -> QuorumResult:
        if quorum_type == QuorumType.SIMPLE_MAJORITY:
            required = total_eligible * 0.5
        elif quorum_type == QuorumType.SUPER_MAJORITY:
            required = total_eligible * 2/3
        elif quorum_type == QuorumType.PHI_WEIGHTED:
            required = total_eligible * PHI_INV
        else:
            required = float(total_eligible)

        actual = float(total_voted)
        return QuorumResult(
            required=required, actual=actual,
            met=actual >= required, quorum_type=quorum_type,
        )
