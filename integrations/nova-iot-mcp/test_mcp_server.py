from __future__ import annotations

import unittest

from mcp_server import NovaMcpServer


class NovaMcpServerTests(unittest.TestCase):
    def setUp(self) -> None:
        self.server = NovaMcpServer()

    def request(self, request_id: int, method: str, params: dict | None = None) -> dict | None:
        return self.server.handle({"jsonrpc": "2.0", "id": request_id, "method": method, "params": params or {}})

    def initialize(self) -> dict:
        response = self.request(1, "initialize", {
            "protocolVersion": "2025-06-18",
            "capabilities": {},
            "clientInfo": {"name": "nova-test", "version": "1"},
        })
        assert response is not None
        return response

    def test_requires_initialize(self) -> None:
        response = self.request(1, "tools/list")
        self.assertEqual(response["error"]["code"], -32002)

    def test_initialize_and_list_tools(self) -> None:
        response = self.initialize()
        self.assertEqual(response["result"]["serverInfo"]["name"], "nova-iot-mcp")
        tools = self.request(2, "tools/list")["result"]["tools"]
        names = {tool["name"] for tool in tools}
        self.assertIn("nova_iot_read_sensor", names)
        self.assertIn("nova_iot_set_relay", names)

    def test_sensor_call_returns_structured_content(self) -> None:
        self.initialize()
        response = self.request(2, "tools/call", {
            "name": "nova_iot_read_sensor",
            "arguments": {"metric": "temperature_c"},
        })
        result = response["result"]
        self.assertFalse(result["isError"])
        self.assertTrue(result["structuredContent"]["ok"])
        self.assertTrue(result["structuredContent"]["result"]["simulated"])

    def test_relay_requires_approval(self) -> None:
        self.initialize()
        response = self.request(2, "tools/call", {
            "name": "nova_iot_set_relay",
            "arguments": {"state": True},
        })
        self.assertTrue(response["result"]["isError"])

    def test_resources(self) -> None:
        self.initialize()
        resources = self.request(2, "resources/list")["result"]["resources"]
        self.assertEqual({item["uri"] for item in resources}, {"nova://devices", "nova://receipts"})
        response = self.request(3, "resources/read", {"uri": "nova://devices"})
        self.assertIn("lab-sensor-01", response["result"]["contents"][0]["text"])

    def test_unknown_method(self) -> None:
        self.initialize()
        response = self.request(2, "unknown/method")
        self.assertEqual(response["error"]["code"], -32601)


if __name__ == "__main__":
    unittest.main()
