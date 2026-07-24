from __future__ import annotations

from dataclasses import asdict
import json
import secrets
import sys
import time
from typing import Any

from robot_access import RobotCommand
from robot_mcp_server import NovaRobotMcpServer
from robot_trust import ApprovalBinding, RobotTrustStore, digest


SERVER_INFO = {"name": "nova-robot-access-mcp", "version": "0.2.0-alpha-secure"}


class NovaSecureRobotMcpServer(NovaRobotMcpServer):
    """Canonical robot MCP entrypoint with durable trust enforcement."""

    def __init__(self, trust_path: str | None = None) -> None:
        super().__init__()
        self.trust = RobotTrustStore(trust_path)

    def handle(self, message: dict[str, Any]) -> dict[str, Any] | None:
        response = super().handle(message)
        if message.get("method") == "initialize" and response and "result" in response:
            response["result"]["serverInfo"] = SERVER_INFO
            response["result"]["instructions"] = (
                "NOVA secure robot/device MCP. Agent and operator identities are authenticated; "
                "execute-tier commands require proposal-bound expiring approvals, atomic durable "
                "nonces and hash-chained durable receipts. Vendor transport remains in local gateways."
            )
        return response

    def _tools(self) -> list[dict[str, Any]]:
        return [
            {
                "name": "nova_robot_list_access_points",
                "description": "List governed robot, industrial, building, vision and edge access points.",
                "inputSchema": {"type": "object", "properties": {}, "additionalProperties": False},
                "annotations": {"readOnlyHint": True, "destructiveHint": False, "idempotentHint": True, "openWorldHint": False},
            },
            {
                "name": "nova_robot_plan_task",
                "description": "Create and durably register an authenticated, proposal-bound robot task plan. Never executes.",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "instruction": {"type": "string", "minLength": 1},
                        "device_id": {"type": "string", "minLength": 1},
                        "preferred_access": {"type": "string"},
                        "arguments": {"type": "object"},
                        "agent_id": {"type": "string", "minLength": 1},
                        "agent_token": {"type": "string", "minLength": 1},
                    },
                    "required": ["instruction", "device_id", "agent_id", "agent_token"],
                    "additionalProperties": False,
                },
                "annotations": {"readOnlyHint": False, "destructiveHint": False, "idempotentHint": False, "openWorldHint": False},
            },
            {
                "name": "nova_robot_approve_proposal",
                "description": "Issue a cryptographically bound, expiring approval for one registered proposal.",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "proposal_hash": {"type": "string", "minLength": 66},
                        "access_id": {"type": "string", "minLength": 1},
                        "device_id": {"type": "string", "minLength": 1},
                        "capability": {"type": "string", "minLength": 1},
                        "arguments": {"type": "object"},
                        "risk_tier": {"type": "string", "enum": ["execute", "critical"]},
                        "approver_id": {"type": "string", "minLength": 1},
                        "operator_token": {"type": "string", "minLength": 1},
                        "ttl_seconds": {"type": "integer", "minimum": 1, "maximum": 900, "default": 120},
                    },
                    "required": ["proposal_hash", "access_id", "device_id", "capability", "arguments", "risk_tier", "approver_id", "operator_token"],
                    "additionalProperties": False,
                },
                "annotations": {"readOnlyHint": False, "destructiveHint": False, "idempotentHint": False, "openWorldHint": False},
            },
            {
                "name": "nova_robot_set_promotion_status",
                "description": "Set a local device promotion state after authenticating the operator.",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "device_id": {"type": "string", "minLength": 1},
                        "status": {"type": "string", "enum": ["DISCOVERED", "OBSERVE", "SIMULATE", "SUPERVISED", "CERTIFIED"]},
                        "approver_id": {"type": "string", "minLength": 1},
                        "operator_token": {"type": "string", "minLength": 1},
                    },
                    "required": ["device_id", "status", "approver_id", "operator_token"],
                    "additionalProperties": False,
                },
                "annotations": {"readOnlyHint": False, "destructiveHint": False, "idempotentHint": True, "openWorldHint": False},
            },
            {
                "name": "nova_robot_invoke",
                "description": "Invoke through the trust boundary. Execute-tier calls require an exact proposal-bound approval.",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "proposal_hash": {"type": "string"},
                        "approval_id": {"type": "string"},
                        "access_id": {"type": "string", "minLength": 1},
                        "device_id": {"type": "string", "minLength": 1},
                        "capability": {"type": "string", "minLength": 1},
                        "arguments": {"type": "object"},
                        "risk_tier": {"type": "string", "enum": ["observe", "simulate", "prepare", "execute", "critical"]},
                        "dry_run": {"type": "boolean", "default": True},
                        "deadline_seconds": {"type": "integer", "minimum": 1, "maximum": 300, "default": 30},
                        "nonce": {"type": "string", "minLength": 16},
                        "agent_id": {"type": "string", "minLength": 1},
                        "agent_token": {"type": "string", "minLength": 1},
                    },
                    "required": ["access_id", "device_id", "capability", "arguments", "risk_tier", "nonce", "agent_id", "agent_token"],
                    "additionalProperties": False,
                },
                "annotations": {"readOnlyHint": False, "destructiveHint": True, "idempotentHint": False, "openWorldHint": False},
            },
            {
                "name": "nova_robot_verify_receipts",
                "description": "Verify the durable robot receipt chain and return its current head.",
                "inputSchema": {"type": "object", "properties": {}, "additionalProperties": False},
                "annotations": {"readOnlyHint": True, "destructiveHint": False, "idempotentHint": True, "openWorldHint": False},
            },
        ]

    @staticmethod
    def _binding(arguments: dict[str, Any]) -> ApprovalBinding:
        return ApprovalBinding(
            access_id=str(arguments.get("access_id", "")),
            device_id=str(arguments.get("device_id", "")),
            capability=str(arguments.get("capability", "")),
            arguments_hash=digest(dict(arguments.get("arguments") or {})),
            risk_tier=str(arguments.get("risk_tier", "")),
            proposal_hash=str(arguments.get("proposal_hash", "")),
        )

    def _call_tool(self, request_id: Any, params: dict[str, Any]) -> dict[str, Any]:
        name = params.get("name")
        arguments = params.get("arguments") or {}
        if not isinstance(arguments, dict):
            return self._error(request_id, -32602, "Tool arguments must be an object")
        try:
            if name == "nova_robot_list_access_points":
                return self._tool_result(request_id, self.registry.list_access_points())

            if name == "nova_robot_verify_receipts":
                return self._tool_result(request_id, self.trust.verify_receipts())

            if name == "nova_robot_plan_task":
                agent_id = str(arguments.get("agent_id", ""))
                self.trust.authenticate_agent(agent_id, str(arguments.get("agent_token", "")))
                instruction = str(arguments.get("instruction", "")).strip()
                device_id = str(arguments.get("device_id", "")).strip()
                if not instruction or not device_id:
                    raise ValueError("instruction and device_id are required")
                proposal = self.planner.plan(instruction, device_id, arguments.get("preferred_access"))
                proposal["arguments"] = dict(arguments.get("arguments") or proposal.get("arguments") or {})
                proposal["arguments_hash"] = digest(proposal["arguments"])
                proposal["agent_id"] = agent_id
                proposal.pop("proposal_hash", None)
                proposal["proposal_hash"] = digest(proposal)
                self.trust.register_proposal(proposal, agent_id)
                return self._tool_result(request_id, proposal)

            if name == "nova_robot_approve_proposal":
                approver_id = str(arguments.get("approver_id", ""))
                self.trust.authenticate_operator(approver_id, str(arguments.get("operator_token", "")))
                binding = self._binding(arguments)
                approval = self.trust.issue_approval(binding, approver_id, int(arguments.get("ttl_seconds", 120)))
                return self._tool_result(request_id, approval)

            if name == "nova_robot_set_promotion_status":
                approver_id = str(arguments.get("approver_id", ""))
                self.trust.authenticate_operator(approver_id, str(arguments.get("operator_token", "")))
                device_id = str(arguments.get("device_id", "")).strip()
                status = str(arguments.get("status", "")).strip()
                self.registry.set_device_status(device_id, status)
                return self._tool_result(request_id, {"ok": True, "device_id": device_id, "status": status, "set_by": approver_id})

            if name == "nova_robot_invoke":
                agent_id = str(arguments.get("agent_id", ""))
                self.trust.authenticate_agent(agent_id, str(arguments.get("agent_token", "")))
                deadline_seconds = int(arguments.get("deadline_seconds", 30))
                if not 1 <= deadline_seconds <= 300:
                    raise ValueError("deadline_seconds must be between 1 and 300")
                command = RobotCommand(
                    access_id=str(arguments.get("access_id", "")),
                    device_id=str(arguments.get("device_id", "")),
                    capability=str(arguments.get("capability", "")),
                    arguments=dict(arguments.get("arguments") or {}),
                    risk_tier=str(arguments.get("risk_tier", "observe")),
                    dry_run=bool(arguments.get("dry_run", True)),
                    approval_id=arguments.get("approval_id"),
                    deadline=int(time.time()) + deadline_seconds,
                    nonce=str(arguments.get("nonce", "")),
                )
                command_hash = command.hash()
                proposal_hash = str(arguments.get("proposal_hash", "")) or None
                if command.risk_tier in {"execute", "critical"}:
                    if not proposal_hash or not command.approval_id:
                        raise PermissionError("execute-tier command requires proposal_hash and approval_id")
                    self.trust.verify_approval(str(command.approval_id), self._binding(arguments))
                self.trust.consume_nonce(command.nonce, command_hash)
                try:
                    result = self.registry.invoke(command)
                    payload = asdict(result)
                    status = "simulated" if command.dry_run else "executed"
                except Exception as exc:
                    payload = {"ok": False, "error": type(exc).__name__, "message": str(exc)}
                    status = "denied" if isinstance(exc, PermissionError) else "failed"
                    receipt = self.trust.append_receipt(
                        command_hash=command_hash,
                        proposal_hash=proposal_hash,
                        approval_id=command.approval_id,
                        agent_id=agent_id,
                        device_id=command.device_id,
                        access_id=command.access_id,
                        capability=command.capability,
                        status=status,
                        result=payload,
                    )
                    return self._tool_result(request_id, {**payload, "receipt": receipt}, is_error=True)
                receipt = self.trust.append_receipt(
                    command_hash=command_hash,
                    proposal_hash=proposal_hash,
                    approval_id=command.approval_id,
                    agent_id=agent_id,
                    device_id=command.device_id,
                    access_id=command.access_id,
                    capability=command.capability,
                    status=status,
                    result=payload,
                )
                return self._tool_result(request_id, {**payload, "receipt": receipt})

            return self._error(request_id, -32602, "Unknown tool", {"name": name})
        except (ValueError, KeyError, PermissionError) as exc:
            return self._tool_result(request_id, {"ok": False, "error": str(exc)}, is_error=True)
        except Exception as exc:
            return self._tool_result(request_id, {"ok": False, "error": type(exc).__name__}, is_error=True)

    def _read_resource(self, request_id: Any, uri: str) -> dict[str, Any]:
        if uri == "nova://robot/receipts":
            payload: Any = {"verification": self.trust.verify_receipts(), "receipts": self.trust.list_receipts()}
            return self._result(request_id, {"contents": [{
                "uri": uri,
                "mimeType": "application/json",
                "text": json.dumps(payload, sort_keys=True),
            }]})
        return super()._read_resource(request_id, uri)


def run_stdio() -> None:
    server = NovaSecureRobotMcpServer()
    for raw_line in sys.stdin:
        line = raw_line.strip()
        if not line:
            continue
        try:
            message = json.loads(line)
            response = server.handle(message) if isinstance(message, dict) else server._error(None, -32600, "Invalid Request")
        except json.JSONDecodeError as exc:
            response = server._error(None, -32700, "Parse error", {"message": str(exc)})
        except Exception as exc:
            response = server._error(None, -32603, "Internal error", {"type": type(exc).__name__})
        if response is not None:
            sys.stdout.write(json.dumps(response, separators=(",", ":")) + "\n")
            sys.stdout.flush()


if __name__ == "__main__":
    run_stdio()
