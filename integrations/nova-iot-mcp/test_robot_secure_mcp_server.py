from __future__ import annotations

import os
import tempfile
import unittest

from robot_secure_mcp_server import NovaSecureRobotMcpServer


class SecureRobotMcpTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temp = tempfile.NamedTemporaryFile(suffix=".db", delete=False)
        self.temp.close()
        os.environ["NOVA_ROBOT_AGENT_ID"] = "agent-test"
        os.environ["NOVA_ROBOT_AGENT_TOKEN"] = "agent-secret"
        os.environ["NOVA_ROBOT_APPROVER_ID"] = "operator-test"
        os.environ["NOVA_ROBOT_OPERATOR_TOKEN"] = "operator-secret"
        os.environ["NOVA_ROBOT_APPROVAL_SECRET"] = "approval-signing-secret"
        self.server = NovaSecureRobotMcpServer(self.temp.name)
        self.server.handle({
            "jsonrpc": "2.0",
            "id": 1,
            "method": "initialize",
            "params": {"protocolVersion": "2025-06-18", "clientInfo": {"name": "test", "version": "1"}},
        })

    def tearDown(self) -> None:
        self.server.trust._conn.close()
        try:
            os.unlink(self.temp.name)
        except FileNotFoundError:
            pass

    def call(self, name: str, arguments: dict) -> dict:
        response = self.server.handle({
            "jsonrpc": "2.0",
            "id": 2,
            "method": "tools/call",
            "params": {"name": name, "arguments": arguments},
        })
        assert response is not None
        return response["result"]["structuredContent"]

    def test_secure_tool_surface_replaces_unbound_execution(self) -> None:
        response = self.server.handle({"jsonrpc": "2.0", "id": 2, "method": "tools/list", "params": {}})
        assert response is not None
        names = {item["name"] for item in response["result"]["tools"]}
        self.assertIn("nova_robot_approve_proposal", names)
        self.assertIn("nova_robot_verify_receipts", names)

    def test_agent_authentication_fails_closed(self) -> None:
        result = self.call("nova_robot_plan_task", {
            "instruction": "navigate to loading bay",
            "device_id": "turtlebot-01",
            "preferred_access": "ros2",
            "agent_id": "agent-test",
            "agent_token": "wrong",
        })
        self.assertFalse(result["ok"])
        self.assertIn("authentication", result["error"])

    def test_proposal_bound_approval_and_durable_receipt(self) -> None:
        proposal = self.call("nova_robot_plan_task", {
            "instruction": "navigate to loading bay",
            "device_id": "turtlebot-01",
            "preferred_access": "ros2",
            "arguments": {"x": 1.0, "y": 2.0},
            "agent_id": "agent-test",
            "agent_token": "agent-secret",
        })
        self.call("nova_robot_set_promotion_status", {
            "device_id": "turtlebot-01",
            "status": "SIMULATE",
            "approver_id": "operator-test",
            "operator_token": "operator-secret",
        })
        approval = self.call("nova_robot_approve_proposal", {
            "proposal_hash": proposal["proposal_hash"],
            "access_id": "ros2",
            "device_id": "turtlebot-01",
            "capability": "robot.nav.goal",
            "arguments": {"x": 1.0, "y": 2.0},
            "risk_tier": "execute",
            "approver_id": "operator-test",
            "operator_token": "operator-secret",
        })
        result = self.call("nova_robot_invoke", {
            "proposal_hash": proposal["proposal_hash"],
            "approval_id": approval["approval_id"],
            "access_id": "ros2",
            "device_id": "turtlebot-01",
            "capability": "robot.nav.goal",
            "arguments": {"x": 1.0, "y": 2.0},
            "risk_tier": "execute",
            "dry_run": True,
            "nonce": "nonce-secure-test-0001",
            "agent_id": "agent-test",
            "agent_token": "agent-secret",
        })
        self.assertTrue(result["ok"])
        self.assertIn("receipt", result)
        verification = self.call("nova_robot_verify_receipts", {})
        self.assertTrue(verification["valid"])
        self.assertEqual(verification["count"], 1)

    def test_approval_cannot_be_reused_for_changed_arguments(self) -> None:
        proposal = self.call("nova_robot_plan_task", {
            "instruction": "set velocity",
            "device_id": "go2-01",
            "preferred_access": "unitree",
            "arguments": {"linear_x": 0.1},
            "agent_id": "agent-test",
            "agent_token": "agent-secret",
        })
        self.call("nova_robot_set_promotion_status", {
            "device_id": "go2-01",
            "status": "SIMULATE",
            "approver_id": "operator-test",
            "operator_token": "operator-secret",
        })
        approval = self.call("nova_robot_approve_proposal", {
            "proposal_hash": proposal["proposal_hash"],
            "access_id": "unitree",
            "device_id": "go2-01",
            "capability": "robot.velocity.set",
            "arguments": {"linear_x": 0.1},
            "risk_tier": "execute",
            "approver_id": "operator-test",
            "operator_token": "operator-secret",
        })
        result = self.call("nova_robot_invoke", {
            "proposal_hash": proposal["proposal_hash"],
            "approval_id": approval["approval_id"],
            "access_id": "unitree",
            "device_id": "go2-01",
            "capability": "robot.velocity.set",
            "arguments": {"linear_x": 2.0},
            "risk_tier": "execute",
            "dry_run": True,
            "nonce": "nonce-secure-test-0002",
            "agent_id": "agent-test",
            "agent_token": "agent-secret",
        })
        self.assertFalse(result["ok"])
        self.assertIn("binding", result["error"])

    def test_nonce_is_atomic_and_persistent(self) -> None:
        first = self.call("nova_robot_invoke", {
            "access_id": "ros2",
            "device_id": "turtlebot-01",
            "capability": "robot.state.read",
            "arguments": {},
            "risk_tier": "observe",
            "dry_run": True,
            "nonce": "nonce-secure-test-0003",
            "agent_id": "agent-test",
            "agent_token": "agent-secret",
        })
        self.assertTrue(first["ok"])
        second = self.call("nova_robot_invoke", {
            "access_id": "ros2",
            "device_id": "turtlebot-01",
            "capability": "robot.state.read",
            "arguments": {},
            "risk_tier": "observe",
            "dry_run": True,
            "nonce": "nonce-secure-test-0003",
            "agent_id": "agent-test",
            "agent_token": "agent-secret",
        })
        self.assertFalse(second["ok"])
        self.assertIn("nonce", second["error"])


if __name__ == "__main__":
    unittest.main()
