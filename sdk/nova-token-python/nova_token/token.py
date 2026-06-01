"""NOVA Token — Token & Ledger"""
import time
from dataclasses import dataclass, field
from typing import Dict, List
from .constants import *


@dataclass
class Token:
    name: str
    symbol: str
    total_supply: float
    decimals: int = 18


class TokenLedger:
    """In-memory token ledger tracking balances."""

    def __init__(self, token: Token):
        self.token = token
        self._balances: Dict[str, float] = {}
        self._supply = token.total_supply

    def mint_to(self, account: str, amount: float) -> bool:
        if amount <= 0:
            return False
        self._balances[account] = self._balances.get(account, 0.0) + amount
        return True

    def transfer(self, sender: str, recipient: str, amount: float) -> bool:
        if self._balances.get(sender, 0.0) < amount or amount <= 0:
            return False
        self._balances[sender] -= amount
        self._balances[recipient] = self._balances.get(recipient, 0.0) + amount
        return True

    def burn(self, account: str, amount: float) -> bool:
        if self._balances.get(account, 0.0) < amount:
            return False
        self._balances[account] -= amount
        self._supply -= amount
        return True

    def balance_of(self, account: str) -> float:
        return self._balances.get(account, 0.0)

    @property
    def total_supply(self) -> float:
        return self._supply

    @property
    def holder_count(self) -> int:
        return sum(1 for b in self._balances.values() if b > 0)
