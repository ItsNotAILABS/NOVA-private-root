from __future__ import annotations

from dataclasses import asdict
import re
import time
from typing import Any, Callable

from protocol import (
    AgentSession,
    DeviceDescriptor,
    PolicyDecision,
    ReceiptChain,
    ToolDescriptor,
    ToolIntent,
    digest,
)

_SECRET_PATTERN = re.compile(r"(secret|private[_-]?key|seed|mnemonic|password|token)", re.IGNORECASE)


class NovaIoTBridge:
    def __init__(self) -> None:
        self.sessions: dict[str, AgentSession] = {}
        self.devices: dict[str, DeviceDescriptor] = {}
        self.tools: dict[str, ToolDescriptor] = {}
        self.handlers: dict[str, Callable[[dict[str, Any], DeviceDescriptor], dict[str, Any]]] = {}
        self.consumed_nonces: set[str] = set()
        self.receipts = ReceiptChain()
        self.policy = {
            "allowed_servers": {"nova-local-iot", "nova-sim-lab"},
            "allowed_tools": set(),
            "allowed_device_types": {"sensor", "relay", "robot", "lab-instrument", "camera", "gateway"},
            "require_approval_for": {"execute", "critical"},
            "require_sandbox_for": {"simulate", "prepare", "execute", "critical"},
            "maximum_value_usd": 1000.0,
        }

    def register_session(self, session: AgentSession) -> None:
        self.sessions[session.session_id] = session

    def register_device(self, device: DeviceDescriptor) -> None:
        self.devices[device.device_id] = device

    def register_tool(
        self,
        descriptor: ToolDescriptor,
        handler: Callable[[dict[str, Any], DeviceDescriptor], dict[str, Any]],
    ) -> None:
        self.tools[descriptor.key] = descriptor
        self.handlers[descriptor.key] = handler
        self.policy["allowed_tools"].add(descriptor.key)

    def _contains_secret(self, value: Any) -> bool:
        if isinstance(value, dict):
            return any(_SECRET_PATTERN.search(str(key)) or self._contains_secret(item) for key, item in value.items())
        if isinstance(value, list):
            return any(self._contains_secret(item) for item in value)
        return False

    def evaluate(self, intent: ToolIntent, now: int | None = None) -> PolicyDecision:
        current = int(time.time()) if now is None else now
        session = self.sessions.get(intent.session_id)
        device = self.devices.get(intent.device_id)
        tool_key = f"{intent.server_id}:{intent.tool_name}"
        tool = self.tools.get(tool_key)

        checks = {
            "session_exists": session is not None,
            "session_active": bool(session and session.active(current)),
            "agent_matches": bool(session and session.agent_id == intent.agent_id),
            "capability_granted": bool(session and intent.capability in session.capabilities),
            "deadline_valid": current <= intent.deadline,
            "nonce_unused": intent.intent_nonce not in self.consumed_nonces,
            "device_exists": device is not None,
            "device_online": bool(device and device.online),
            "device_capable": bool(device and intent.capability in device.capabilities),
            "tool_exists": tool is not None,
            "tool_allowed": tool_key in self.policy["allowed_tools"],
            "server_allowed": intent.server_id in self.policy["allowed_servers"],
            "tool_capability_matches": bool(tool and tool.capability == intent.capability),
            "risk_matches": bool(tool and tool.risk_tier == intent.risk_tier),
            "device_type_allowed": bool(device and device.device_type in self.policy["allowed_device_types"]),
            "tool_accepts_device": bool(device and tool and device.device_type in tool.allowed_device_types),
            "no_secrets": not self._contains_secret(intent.arguments),
        }

        flags = tuple(key for key, passed in checks.items() if not passed)
        if flags:
            return PolicyDecision(False, "denied", intent.hash(), checks, flags, "one or more mandatory controls failed")

        assert tool is not None
        if intent.risk_tier in self.policy["require_approval_for"] and not intent.approval_id:
            return PolicyDecision(False, "approval-required", intent.hash(), checks, ("approval-missing",), "human or multisig approval required")

        if intent.dry_run or intent.risk_tier == "simulate":
            mode = "sandboxed"
        elif intent.risk_tier == "observe":
            mode = "observe"
        else:
            mode = "execute"

        return PolicyDecision(True, mode, intent.hash(), checks, (), "intent passed the NOVA IoT governance boundary")

    def invoke(self, intent: ToolIntent, now: int | None = None) -> dict[str, Any]:
        started_at = int(time.time()) if now is None else now
        decision = self.evaluate(intent, started_at)
        tool_key = f"{intent.server_id}:{intent.tool_name}"
        policy_snapshot = {
            "decision": asdict(decision),
            "allowed_servers": sorted(self.policy["allowed_servers"]),
            "allowed_tools": sorted(self.policy["allowed_tools"]),
        }

        if not decision.allowed:
            receipt = self.receipts.append(
                intent=intent,
                device_id=intent.device_id,
                tool_key=tool_key,
                status="denied",
                started_at=started_at,
                result={"risk_flags": list(decision.risk_flags), "reason": decision.reason},
                policy=policy_snapshot,
            )
            return {"ok": False, "decision": asdict(decision), "receipt": asdict(receipt)}

        self.consumed_nonces.add(intent.intent_nonce)
        device = self.devices[intent.device_id]
        handler = self.handlers[tool_key]

        try:
            result = handler(dict(intent.arguments), device)
            status = "simulated" if decision.execution_mode == "sandboxed" else "executed"
        except Exception as exc:  # bridge must return a receipt even on tool failure
            result = {"error": type(exc).__name__, "message": str(exc)}
            status = "failed"

        redacted = self._redact(result)
        receipt = self.receipts.append(
            intent=intent,
            device_id=device.device_id,
            tool_key=tool_key,
            status=status,
            started_at=started_at,
            result=redacted,
            policy=policy_snapshot,
        )
        return {
            "ok": status not in {"failed", "denied"},
            "decision": asdict(decision),
            "result": redacted,
            "receipt": asdict(receipt),
            "receipt_chain_head": self.receipts.head,
            "receipt_chain_valid": self.receipts.verify(),
            "icp_anchor_payload": {
                "namespace": "nova.iot.execution.receipt.v1",
                "receipt_hash": receipt.receipt_hash,
                "intent_hash": receipt.intent_hash,
                "device_id": receipt.device_id,
                "evidence_hash": digest({"result": redacted, "policy_hash": receipt.policy_hash}),
            },
        }

    def _redact(self, value: Any) -> Any:
        if isinstance(value, dict):
            return {
                key: "[REDACTED]" if _SECRET_PATTERN.search(str(key)) else self._redact(item)
                for key, item in value.items()
            }
        if isinstance(value, list):
            return [self._redact(item) for item in value]
        return value
