from __future__ import annotations

from dataclasses import asdict, dataclass, field
from hashlib import sha256
import json
import time
from typing import Any, Literal

RiskTier = Literal["observe", "simulate", "prepare", "execute", "critical"]


def canonical_json(value: Any) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=True)


def digest(value: Any) -> str:
    return "0x" + sha256(canonical_json(value).encode("utf-8")).hexdigest()


@dataclass(frozen=True)
class AgentSession:
    session_id: str
    agent_id: str
    card_version: int
    capabilities: tuple[str, ...]
    issued_at: int
    expires_at: int
    nonce: str

    def active(self, now: int | None = None) -> bool:
        current = int(time.time()) if now is None else now
        return self.issued_at <= current < self.expires_at


@dataclass(frozen=True)
class DeviceDescriptor:
    device_id: str
    device_type: str
    namespace: str
    capabilities: tuple[str, ...]
    online: bool
    requires_sandbox: bool = False
    metadata: dict[str, Any] = field(default_factory=dict)


@dataclass(frozen=True)
class ToolDescriptor:
    server_id: str
    tool_name: str
    capability: str
    risk_tier: RiskTier
    input_schema_hash: str
    output_schema_hash: str
    allowed_device_types: tuple[str, ...]
    timeout_ms: int
    requires_human_approval: bool = False
    maximum_value_usd: float = 0.0

    @property
    def key(self) -> str:
        return f"{self.server_id}:{self.tool_name}"


@dataclass(frozen=True)
class ToolIntent:
    request_id: str
    session_id: str
    agent_id: str
    capability: str
    server_id: str
    tool_name: str
    device_id: str
    arguments: dict[str, Any]
    risk_tier: RiskTier
    intent_nonce: str
    deadline: int
    approval_id: str | None = None
    dry_run: bool = True

    def hash(self) -> str:
        return digest(asdict(self))


@dataclass(frozen=True)
class PolicyDecision:
    allowed: bool
    execution_mode: Literal["denied", "observe", "sandboxed", "approval-required", "execute"]
    intent_hash: str
    checks: dict[str, bool]
    risk_flags: tuple[str, ...]
    reason: str


@dataclass(frozen=True)
class ExecutionReceipt:
    receipt_id: str
    intent_hash: str
    previous_receipt_hash: str
    device_id: str
    tool_key: str
    status: Literal["simulated", "prepared", "executed", "denied", "failed"]
    started_at: int
    completed_at: int
    result_hash: str
    redacted_result: dict[str, Any]
    policy_hash: str
    receipt_hash: str


class ReceiptChain:
    def __init__(self) -> None:
        self._receipts: list[ExecutionReceipt] = []

    @property
    def head(self) -> str:
        return self._receipts[-1].receipt_hash if self._receipts else "0x" + "0" * 64

    def append(
        self,
        *,
        intent: ToolIntent,
        device_id: str,
        tool_key: str,
        status: Literal["simulated", "prepared", "executed", "denied", "failed"],
        started_at: int,
        result: dict[str, Any],
        policy: dict[str, Any],
    ) -> ExecutionReceipt:
        completed_at = int(time.time())
        result_hash = digest(result)
        policy_hash = digest(policy)
        payload = {
            "intent_hash": intent.hash(),
            "previous_receipt_hash": self.head,
            "device_id": device_id,
            "tool_key": tool_key,
            "status": status,
            "started_at": started_at,
            "completed_at": completed_at,
            "result_hash": result_hash,
            "policy_hash": policy_hash,
        }
        receipt_hash = digest(payload)
        receipt = ExecutionReceipt(
            receipt_id=f"nova-iot-{len(self._receipts) + 1:08d}",
            intent_hash=intent.hash(),
            previous_receipt_hash=self.head,
            device_id=device_id,
            tool_key=tool_key,
            status=status,
            started_at=started_at,
            completed_at=completed_at,
            result_hash=result_hash,
            redacted_result=result,
            policy_hash=policy_hash,
            receipt_hash=receipt_hash,
        )
        self._receipts.append(receipt)
        return receipt

    def export(self) -> list[dict[str, Any]]:
        return [asdict(item) for item in self._receipts]

    def verify(self) -> bool:
        previous = "0x" + "0" * 64
        for receipt in self._receipts:
            payload = {
                "intent_hash": receipt.intent_hash,
                "previous_receipt_hash": previous,
                "device_id": receipt.device_id,
                "tool_key": receipt.tool_key,
                "status": receipt.status,
                "started_at": receipt.started_at,
                "completed_at": receipt.completed_at,
                "result_hash": receipt.result_hash,
                "policy_hash": receipt.policy_hash,
            }
            if receipt.previous_receipt_hash != previous or receipt.receipt_hash != digest(payload):
                return False
            previous = receipt.receipt_hash
        return True
