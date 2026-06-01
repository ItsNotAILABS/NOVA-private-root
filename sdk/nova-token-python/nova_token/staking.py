"""NOVA Token — Staking"""
import time
import hashlib
from dataclasses import dataclass, field
from typing import Dict, List
from .constants import *


@dataclass
class Stake:
    stake_id: str
    staker: str
    amount: float
    state: StakeState = StakeState.STAKED
    staked_ms: float = field(default_factory=lambda: time.time() * 1000)
    rewards_earned: float = 0.0


@dataclass
class StakeReward:
    stake_id: str
    amount: float
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)


class StakingPool:
    """φ-weighted staking pool."""

    def __init__(self, reward_rate: float = PHI_INV * 0.01):
        self.reward_rate = reward_rate
        self._stakes: Dict[str, Stake] = {}

    def stake(self, staker: str, amount: float) -> Stake:
        sid = hashlib.sha256(f"{staker}{amount}{time.time()}".encode()).hexdigest()[:12]
        s = Stake(stake_id=sid, staker=staker, amount=amount)
        self._stakes[sid] = s
        return s

    def unstake(self, stake_id: str) -> bool:
        s = self._stakes.get(stake_id)
        if s and s.state == StakeState.STAKED:
            s.state = StakeState.UNSTAKING
            return True
        return False

    def distribute_rewards(self) -> List[StakeReward]:
        """Distribute φ-weighted rewards to all stakers."""
        rewards = []
        total_staked = sum(s.amount for s in self._stakes.values() if s.state == StakeState.STAKED)
        if total_staked == 0:
            return []
        for s in self._stakes.values():
            if s.state != StakeState.STAKED:
                continue
            reward = s.amount * self.reward_rate * PHI_INV
            s.rewards_earned += reward
            rewards.append(StakeReward(stake_id=s.stake_id, amount=reward))
        return rewards

    @property
    def total_staked(self) -> float:
        return sum(s.amount for s in self._stakes.values() if s.state == StakeState.STAKED)

    @property
    def staker_count(self) -> int:
        return sum(1 for s in self._stakes.values() if s.state == StakeState.STAKED)
