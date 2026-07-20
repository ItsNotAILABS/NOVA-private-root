#include "nova/nova_client.hpp"

#include <iostream>

int main(int argc, char** argv) {
  nova::ClientConfig cfg;
  if (argc > 1) cfg.host = argv[1];
  if (argc > 2) cfg.port = static_cast<unsigned short>(std::stoi(argv[2]));

  nova::Client client(cfg);

  auto tools = client.tools_list();
  if (!tools.ok()) {
    std::cerr << "tools/list failed: " << tools.error() << "\n";
    return 1;
  }

  std::cout << "NOVA MCP tools/list response:\n" << tools.body() << "\n";

  auto status = client.tool_call("nova_status", "{}");
  if (!status.ok()) {
    std::cerr << "nova_status failed: " << status.error() << "\n";
    return 2;
  }

  std::cout << "\nNOVA nova_status response:\n" << status.body() << "\n";
  return 0;
}
