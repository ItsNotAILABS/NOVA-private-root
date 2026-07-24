from __future__ import annotations

from dataclasses import asdict, dataclass
from hashlib import sha256
import hmac
import json
import os
import sqlite3
import threading
import time
from typing import Any


def canonical_json(value: Any) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=True)


def digest(value: Any) -> str:
    return "0x" + sha256(canonical_json(value).encode("utf-8")).hexdigest()


@dataclass(frozen=True)
class ApprovalBinding:
    access_id: str
    device_id: str
    capability: str
    arguments_hash: str
    risk_tier: str
    proposal_hash: str

    @property
    def binding_hash(self) -> str:
        return digest(asdict(self))


class RobotTrustStore:
    """SQLite-backed trust substrate for robot execution.

    This store provides atomic nonce consumption, proposal-bound approvals,
    durable hash-chained receipts and explicit agent/operator identities.
    HMAC is used for the alpha boundary so the implementation remains
    dependency-free; production promotion can replace the signer with Ed25519
    without changing the approval/receipt data model.
    """

    def __init__(self, path: str | None = None) -> None:
        self.path = path or os.getenv("NOVA_ROBOT_TRUST_DB", "nova_robot_trust.db")
        self._lock = threading.RLock()
        self._conn = sqlite3.connect(self.path, check_same_thread=False, isolation_level=None)
        self._conn.row_factory = sqlite3.Row
        self._initialize()

    def _initialize(self) -> None:
        with self._lock:
            self._conn.executescript(
                """
                PRAGMA journal_mode=WAL;
                PRAGMA synchronous=FULL;
                PRAGMA foreign_keys=ON;
                CREATE TABLE IF NOT EXISTS proposals (
                    proposal_hash TEXT PRIMARY KEY,
                    payload_json TEXT NOT NULL,
                    agent_id TEXT NOT NULL,
                    created_at INTEGER NOT NULL,
                    expires_at INTEGER NOT NULL
                );
                CREATE TABLE IF NOT EXISTS approvals (
                    approval_id TEXT PRIMARY KEY,
                    proposal_hash TEXT NOT NULL,
                    binding_hash TEXT NOT NULL,
                    approver_id TEXT NOT NULL,
                    issued_at INTEGER NOT NULL,
                    expires_at INTEGER NOT NULL,
                    signature TEXT NOT NULL,
                    revoked_at INTEGER,
                    FOREIGN KEY(proposal_hash) REFERENCES proposals(proposal_hash)
                );
                CREATE TABLE IF NOT EXISTS consumed_nonces (
                    nonce TEXT PRIMARY KEY,
                    command_hash TEXT NOT NULL,
                    consumed_at INTEGER NOT NULL
                );
                CREATE TABLE IF NOT EXISTS receipts (
                    sequence INTEGER PRIMARY KEY AUTOINCREMENT,
                    receipt_id TEXT UNIQUE NOT NULL,
                    previous_hash TEXT NOT NULL,
                    command_hash TEXT NOT NULL,
                    proposal_hash TEXT,
                    approval_id TEXT,
                    agent_id TEXT NOT NULL,
                    device_id TEXT NOT NULL,
                    access_id TEXT NOT NULL,
                    capability TEXT NOT NULL,
                    status TEXT NOT NULL,
                    result_hash TEXT NOT NULL,
                    created_at INTEGER NOT NULL,
                    receipt_hash TEXT UNIQUE NOT NULL
                );
                CREATE INDEX IF NOT EXISTS approvals_proposal_idx ON approvals(proposal_hash);
                CREATE INDEX IF NOT EXISTS receipts_device_idx ON receipts(device_id, sequence);
                """
            )

    @staticmethod
    def _secret(name: str) -> bytes:
        value = os.getenv(name, "")
        if not value:
            raise PermissionError(f"required secret {name} is not configured")
        return value.encode("utf-8")

    @staticmethod
    def authenticate_agent(agent_id: str, presented_token: str) -> None:
        expected_id = os.getenv("NOVA_ROBOT_AGENT_ID", "nova-local-agent")
        expected_token = os.getenv("NOVA_ROBOT_AGENT_TOKEN", "")
        if not expected_token:
            raise PermissionError("NOVA_ROBOT_AGENT_TOKEN is not configured")
        if agent_id != expected_id or not hmac.compare_digest(presented_token, expected_token):
            raise PermissionError("agent authentication failed")

    @staticmethod
    def authenticate_operator(approver_id: str, presented_token: str) -> None:
        expected_id = os.getenv("NOVA_ROBOT_APPROVER_ID", "nova-local-operator")
        expected_token = os.getenv("NOVA_ROBOT_OPERATOR_TOKEN", "")
        if not expected_token:
            raise PermissionError("NOVA_ROBOT_OPERATOR_TOKEN is not configured")
        if approver_id != expected_id or not hmac.compare_digest(presented_token, expected_token):
            raise PermissionError("operator authentication failed")

    def register_proposal(self, proposal: dict[str, Any], agent_id: str, ttl_seconds: int = 300) -> str:
        now = int(time.time())
        proposal_hash = str(proposal.get("proposal_hash") or digest(proposal))
        payload = dict(proposal)
        payload["proposal_hash"] = proposal_hash
        with self._lock:
            self._conn.execute(
                "INSERT OR REPLACE INTO proposals(proposal_hash,payload_json,agent_id,created_at,expires_at) VALUES(?,?,?,?,?)",
                (proposal_hash, canonical_json(payload), agent_id, now, now + ttl_seconds),
            )
        return proposal_hash

    def issue_approval(
        self,
        binding: ApprovalBinding,
        approver_id: str,
        ttl_seconds: int = 120,
    ) -> dict[str, Any]:
        if not 1 <= ttl_seconds <= 900:
            raise ValueError("approval ttl must be between 1 and 900 seconds")
        now = int(time.time())
        row = self._conn.execute(
            "SELECT expires_at FROM proposals WHERE proposal_hash=?",
            (binding.proposal_hash,),
        ).fetchone()
        if row is None or int(row["expires_at"]) < now:
            raise PermissionError("proposal missing or expired")
        approval_id = "nova-appr-" + sha256(f"{binding.binding_hash}:{approver_id}:{now}".encode()).hexdigest()[:24]
        payload = {
            "approval_id": approval_id,
            "proposal_hash": binding.proposal_hash,
            "binding_hash": binding.binding_hash,
            "approver_id": approver_id,
            "issued_at": now,
            "expires_at": now + ttl_seconds,
        }
        signature = hmac.new(self._secret("NOVA_ROBOT_APPROVAL_SECRET"), canonical_json(payload).encode(), sha256).hexdigest()
        with self._lock:
            self._conn.execute(
                "INSERT INTO approvals(approval_id,proposal_hash,binding_hash,approver_id,issued_at,expires_at,signature) VALUES(?,?,?,?,?,?,?)",
                (approval_id, binding.proposal_hash, binding.binding_hash, approver_id, now, now + ttl_seconds, signature),
            )
        return {**payload, "signature": signature}

    def verify_approval(self, approval_id: str, binding: ApprovalBinding) -> dict[str, Any]:
        now = int(time.time())
        row = self._conn.execute("SELECT * FROM approvals WHERE approval_id=?", (approval_id,)).fetchone()
        if row is None:
            raise PermissionError("approval not found")
        payload = {
            "approval_id": row["approval_id"],
            "proposal_hash": row["proposal_hash"],
            "binding_hash": row["binding_hash"],
            "approver_id": row["approver_id"],
            "issued_at": int(row["issued_at"]),
            "expires_at": int(row["expires_at"]),
        }
        expected = hmac.new(self._secret("NOVA_ROBOT_APPROVAL_SECRET"), canonical_json(payload).encode(), sha256).hexdigest()
        checks = {
            "signature_valid": hmac.compare_digest(expected, str(row["signature"])),
            "not_expired": int(row["expires_at"]) >= now,
            "not_revoked": row["revoked_at"] is None,
            "proposal_matches": row["proposal_hash"] == binding.proposal_hash,
            "binding_matches": row["binding_hash"] == binding.binding_hash,
        }
        if not all(checks.values()):
            raise PermissionError("approval verification failed: " + ",".join(k for k, v in checks.items() if not v))
        return {**payload, "checks": checks}

    def consume_nonce(self, nonce: str, command_hash: str) -> None:
        if len(nonce) < 16:
            raise ValueError("nonce must contain at least 16 characters")
        now = int(time.time())
        with self._lock:
            try:
                self._conn.execute("BEGIN IMMEDIATE")
                self._conn.execute(
                    "INSERT INTO consumed_nonces(nonce,command_hash,consumed_at) VALUES(?,?,?)",
                    (nonce, command_hash, now),
                )
                self._conn.execute("COMMIT")
            except sqlite3.IntegrityError as exc:
                self._conn.execute("ROLLBACK")
                raise PermissionError("nonce already consumed") from exc
            except Exception:
                self._conn.execute("ROLLBACK")
                raise

    def append_receipt(
        self,
        *,
        command_hash: str,
        proposal_hash: str | None,
        approval_id: str | None,
        agent_id: str,
        device_id: str,
        access_id: str,
        capability: str,
        status: str,
        result: dict[str, Any],
    ) -> dict[str, Any]:
        now = int(time.time())
        with self._lock:
            self._conn.execute("BEGIN IMMEDIATE")
            try:
                previous_row = self._conn.execute(
                    "SELECT receipt_hash FROM receipts ORDER BY sequence DESC LIMIT 1"
                ).fetchone()
                previous_hash = str(previous_row["receipt_hash"]) if previous_row else "0x" + "0" * 64
                result_hash = digest(result)
                payload = {
                    "previous_hash": previous_hash,
                    "command_hash": command_hash,
                    "proposal_hash": proposal_hash,
                    "approval_id": approval_id,
                    "agent_id": agent_id,
                    "device_id": device_id,
                    "access_id": access_id,
                    "capability": capability,
                    "status": status,
                    "result_hash": result_hash,
                    "created_at": now,
                }
                receipt_hash = digest(payload)
                receipt_id = "nova-robot-" + receipt_hash[2:18]
                self._conn.execute(
                    "INSERT INTO receipts(receipt_id,previous_hash,command_hash,proposal_hash,approval_id,agent_id,device_id,access_id,capability,status,result_hash,created_at,receipt_hash) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)",
                    (receipt_id, previous_hash, command_hash, proposal_hash, approval_id, agent_id, device_id, access_id, capability, status, result_hash, now, receipt_hash),
                )
                self._conn.execute("COMMIT")
                return {"receipt_id": receipt_id, **payload, "receipt_hash": receipt_hash}
            except Exception:
                self._conn.execute("ROLLBACK")
                raise

    def verify_receipts(self) -> dict[str, Any]:
        rows = self._conn.execute("SELECT * FROM receipts ORDER BY sequence").fetchall()
        previous = "0x" + "0" * 64
        for row in rows:
            payload = {
                "previous_hash": previous,
                "command_hash": row["command_hash"],
                "proposal_hash": row["proposal_hash"],
                "approval_id": row["approval_id"],
                "agent_id": row["agent_id"],
                "device_id": row["device_id"],
                "access_id": row["access_id"],
                "capability": row["capability"],
                "status": row["status"],
                "result_hash": row["result_hash"],
                "created_at": int(row["created_at"]),
            }
            if row["previous_hash"] != previous or row["receipt_hash"] != digest(payload):
                return {"valid": False, "count": len(rows), "head": previous}
            previous = row["receipt_hash"]
        return {"valid": True, "count": len(rows), "head": previous}

    def list_receipts(self, limit: int = 100) -> list[dict[str, Any]]:
        rows = self._conn.execute(
            "SELECT * FROM receipts ORDER BY sequence DESC LIMIT ?", (max(1, min(limit, 1000)),)
        ).fetchall()
        return [dict(row) for row in rows]
