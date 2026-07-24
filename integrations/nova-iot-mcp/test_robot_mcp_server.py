from __future__ import annotations

import unittest

from robot_access import RobotCommand, RobotTaskPlanner, build_default_registry
from robot_mcp_server import NovaRobotMcpServer


class RobotAccessTests(unittest.TestCase):
    def setUp(self) -> None:
        self.registry = build_default_registry()

    def test_registry_contains_primary_robot_lanes(self) -> None:
        ids = {item["access_id"] for item in self.registry.list_access_points()}
        self.assertTrue({"ros2", "mqtt", "unitree", "spot", "universal-robots", "franka", "px4", "ardupilot"}.issubset(ids))

    def test_discovered_device_cannot_execute(self) -> None:
        command = RobotCommand(
            access_id="ros2",
            device_id="turtlebot-01",
            capability="robot.nav.goal",
            arguments={"x": 1.0, "y": 2.0},
            risk_tier="execute",
            dry_run=False,
            approval_id="approval-1",
        )
        with self.assertRaises(PermissionError):
            self.registry.invoke(command)

    def test_simulate_device_forces_dry_run(self) -> None:
        self.registry.set_device_status("turtlebot-01", "SIMULATE")
        command = RobotCommand(
            access_id="ros2",
            device_id="turtlebot-01",
            capability="robot.nav.goal",
            arguments={"x": 1.0, "y": 2.0},
            risk_tier="execute",
            dry_run=False,
            approval_id="approval-1",
        )
        with self.assertRaises(PermissionError):
            self.registry.invoke(command)

    def test_supervised_execute_requires_approval(self) -> None:
        self.registry.set_device_status("go2-01", "SUPERVISED")
        command = RobotCommand(
            access_id="unitree",
            device_id="go2-01",
            capability="robot.velocity.set",
            arguments={"linear_x": 0.1},
            risk_tier="execute",
            dry_run=False,
        )
        with self.assertRaises(PermissionError):
            self.registry.invoke(command)

    def test_planner_emits_proposal_not_execution(self) -> None:
        planner = RobotTaskPlanner(self.registry)
        proposal = planner.plan("Navigate to the loading bay", "turtlebot-01", "ros2")
        self.assertEqual(proposal["selected_access_id"], "ros2")
        self.assertEqual(proposal["capability"], "robot.nav.goal")
        self.assertTrue(proposal["dry_run"])
        self.assertTrue(proposal["requires_approval"])
        self.assertTrue(proposal["proposal_hash"].startswith("0x"))


class RobotMcpTests(unittest.TestCase):
    def setUp(self) -> None:
        self.server = NovaRobotMcpServer()
        self.server.handle({
            "jsonrpc": "2.0",
            "id": 1,
            "method": "initialize",
            "params": {"protocolVersion": "2025-06-18", "clientInfo": {"name": "test", "version": "1"}},
        })

    def call(self, name: str, arguments: dict) -> dict:
        response = self.server.handle({
            "jsonrpc": "2.0",
            "id": 2,
            "method": "tools/call",
            "params": {"name": name, "arguments": arguments},
        })
        assert response is not None
        return response["result"]["structuredContent"]

    def test_tool_discovery(self) -> None:
        response = self.server.handle({"jsonrpc": "2.0", "id": 2, "method": "tools/list", "params": {}})
        assert response is not None
        names = {tool["name"] for tool in response["result"]["tools"]}
        self.assertIn("nova_robot_plan_task", names)
        self.assertIn("nova_robot_invoke", names)

    def test_plan_task(self) -> None:
        proposal = self.call("nova_robot_plan_task", {
            "instruction": "Take a camera snapshot",
            "device_id": "camera-01",
            "preferred_access": "onvif",
        })
        self.assertEqual(proposal["capability"], "camera.snapshot")
        self.assertIn("onvif", proposal["candidate_access_points"])

    def test_promote_then_simulate_command(self) -> None:
        promoted = self.call("nova_robot_set_promotion_status", {"device_id": "esp32-01", "status": "SIMULATE"})
        self.assertTrue(promoted["ok"])
        result = self.call("nova_robot_invoke", {
            "access_id": "mqtt",
            "device_id": "esp32-01",
            "capability": "iot.command.publish",
            "arguments": {"topic": "robot/cmd", "payload": {"state": True}},
            "risk_tier": "execute",
            "dry_run": True,
            "approval_id": "approval-test",
        })
        self.assertTrue(result["ok"])
        self.assertEqual(result["mode"], "simulated")

    def test_physical_execute_is_denied_before_supervised(self) -> None:
        result = self.call("nova_robot_invoke", {
            "access_id": "px4",
            "device_id": "drone-01",
            "capability": "vehicle.takeoff",
            "arguments": {"altitude_m": 2},
            "risk_tier": "critical",
            "dry_run": False,
            "approval_id": "approval-test",
        })
        self.assertFalse(result["ok"])


if __name__ == "__main__":
    unittest.main()
