from __future__ import annotations

import time
import unittest

from bridge import NovaIoTBridge
from protocol import AgentSession, DeviceDescriptor, ToolDescriptor, ToolIntent, digest


class NovaIoTBridgeTests(unittest.TestCase):
    def setUp(self) -> None:
        now = int(time.time())
        self.now = now
        self.bridge = NovaIoTBridge()
        self.bridge.register_session(AgentSession(
            session_id="session-00000001",
            agent_id="agent-1",
            card_version=3,
            capabilities=("iot.sensor.read", "iot.relay.set"),
            issued_at=now - 10,
            expires_at=now + 1000,
            nonce="session-nonce-00000001",
        ))
        self.bridge.register_device(DeviceDescriptor(
            device_id="sensor-1",
            device_type="sensor",
            namespace="nova.iot.sensor.1",
            capabilities=("iot.sensor.read",),
            online=True,
        ))
        self.bridge.register_device(DeviceDescriptor(
            device_id="relay-1",
            device_type="relay",
            namespace="nova.iot.relay.1",
            capabilities=("iot.relay.set",),
            online=True,
        ))
        self.bridge.register_tool(ToolDescriptor(
            server_id="nova-local-iot",
            tool_name="read_sensor",
            capability="iot.sensor.read",
            risk_tier="observe",
            input_schema_hash=digest({"metric": "string"}),
            output_schema_hash=digest({"value": "number"}),
            allowed_device_types=("sensor",),
            timeout_ms=1000,
        ), lambda args, device: {"value": 7, "device": device.device_id})
        self.bridge.register_tool(ToolDescriptor(
            server_id="nova-local-iot",
            tool_name="set_relay",
            capability="iot.relay.set",
            risk_tier="execute",
            input_schema_hash=digest({"state": "boolean"}),
            output_schema_hash=digest({"applied": "boolean"}),
            allowed_device_types=("relay",),
            timeout_ms=1000,
            requires_human_approval=True,
        ), lambda args, device: {"applied": bool(args["state"]), "device": device.device_id})

    def intent(self, **changes):
        data = dict(
            request_id="request-1",
            session_id="session-00000001",
            agent_id="agent-1",
            capability="iot.sensor.read",
            server_id="nova-local-iot",
            tool_name="read_sensor",
            device_id="sensor-1",
            arguments={"metric": "temperature"},
            risk_tier="observe",
            intent_nonce="intent-nonce-00000001",
            deadline=self.now + 100,
            approval_id=None,
            dry_run=False,
        )
        data.update(changes)
        return ToolIntent(**data)

    def test_observe_executes_and_seals_receipt(self):
        result = self.bridge.invoke(self.intent(), self.now)
        self.assertTrue(result["ok"])
        self.assertEqual(result["result"]["value"], 7)
        self.assertTrue(result["receipt_chain_valid"])
        self.assertEqual(len(self.bridge.receipts.export()), 1)

    def test_replay_is_denied(self):
        intent = self.intent()
        self.assertTrue(self.bridge.invoke(intent, self.now)["ok"])
        replay = self.bridge.invoke(intent, self.now + 1)
        self.assertFalse(replay["ok"])
        self.assertIn("nonce_unused", replay["decision"]["risk_flags"])

    def test_execute_requires_approval(self):
        intent = self.intent(
            capability="iot.relay.set",
            tool_name="set_relay",
            device_id="relay-1",
            arguments={"state": True},
            risk_tier="execute",
            intent_nonce="intent-nonce-00000002",
        )
        result = self.bridge.invoke(intent, self.now)
        self.assertFalse(result["ok"])
        self.assertEqual(result["decision"]["execution_mode"], "approval-required")

    def test_execute_with_approval(self):
        intent = self.intent(
            capability="iot.relay.set",
            tool_name="set_relay",
            device_id="relay-1",
            arguments={"state": True},
            risk_tier="execute",
            intent_nonce="intent-nonce-00000003",
            approval_id="multisig-approval-1",
            dry_run=False,
        )
        result = self.bridge.invoke(intent, self.now)
        self.assertTrue(result["ok"])
        self.assertTrue(result["result"]["applied"])

    def test_secret_bearing_arguments_are_denied(self):
        result = self.bridge.invoke(self.intent(arguments={"private_key": "never"}, intent_nonce="intent-nonce-00000004"), self.now)
        self.assertFalse(result["ok"])
        self.assertIn("no_secrets", result["decision"]["risk_flags"])


if __name__ == "__main__":
    unittest.main()
