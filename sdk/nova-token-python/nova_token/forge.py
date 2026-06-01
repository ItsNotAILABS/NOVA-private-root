"""NOVA Token — Token Forge"""
import time
import hashlib
from dataclasses import dataclass, field
from typing import Dict, List
from .constants import *
from .token import Token, TokenLedger


@dataclass
class MintRecord:
    mint_id: str
    token_symbol: str
    amount: float
    recipient: str
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)


class TokenForge:
    """Creates and manages tokens."""

    def __init__(self):
        self._tokens: Dict[str, TokenLedger] = {}
        self._mints: List[MintRecord] = []

    def create_token(self, name: str, symbol: str, initial_supply: float = 1000000) -> TokenLedger:
        token = Token(name=name, symbol=symbol, total_supply=initial_supply)
        ledger = TokenLedger(token)
        self._tokens[symbol] = ledger
        return ledger

    def mint(self, symbol: str, recipient: str, amount: float) -> bool:
        ledger = self._tokens.get(symbol)
        if not ledger:
            return False
        success = ledger.mint_to(recipient, amount)
        if success:
            mid = hashlib.sha256(f"{symbol}{recipient}{time.time()}".encode()).hexdigest()[:12]
            self._mints.append(MintRecord(mint_id=mid, token_symbol=symbol,
                                         amount=amount, recipient=recipient))
        return success

    def get_ledger(self, symbol: str):
        return self._tokens.get(symbol)

    @property
    def token_count(self) -> int:
        return len(self._tokens)

    @property
    def total_mints(self) -> int:
        return len(self._mints)
