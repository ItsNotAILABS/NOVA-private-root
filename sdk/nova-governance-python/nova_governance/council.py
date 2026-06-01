"""NOVA Governance — Council"""
import time
from dataclasses import dataclass, field
from typing import Dict, List
from .constants import *


@dataclass
class CouncilMember:
    member_id: str
    name: str
    role: GovernanceRole = GovernanceRole.CITIZEN
    voting_power: float = 1.0
    joined_ms: float = field(default_factory=lambda: time.time() * 1000)
    active: bool = True


class Council:
    """Governance council managing proposals and votes."""

    def __init__(self, name: str = "Sovereign Council"):
        self.name = name
        self._members: Dict[str, CouncilMember] = {}

    def add_member(self, member_id: str, name: str,
                   role: GovernanceRole = GovernanceRole.CITIZEN,
                   voting_power: float = 1.0) -> CouncilMember:
        member = CouncilMember(member_id=member_id, name=name,
                              role=role, voting_power=voting_power)
        self._members[member_id] = member
        return member

    def remove_member(self, member_id: str) -> bool:
        return self._members.pop(member_id, None) is not None

    def get_member(self, member_id: str):
        return self._members.get(member_id)

    @property
    def member_count(self) -> int:
        return len(self._members)

    @property
    def total_voting_power(self) -> float:
        return sum(m.voting_power for m in self._members.values() if m.active)

    @property
    def sovereigns(self) -> List[CouncilMember]:
        return [m for m in self._members.values() if m.role == GovernanceRole.SOVEREIGN]
