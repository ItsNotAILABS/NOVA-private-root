#include "nova/nova_client.hpp"

#include <cassert>
#include <iostream>
#include <string>

int main() {
  const nova_client_config cfg = nova_default_config();
  assert(std::string(cfg.host) == "127.0.0.1");
  assert(cfg.port == 8787);
  assert(cfg.timeout_ms > 0);
  assert(cfg.max_response_bytes > 0);

  assert(std::string(nova_status_code_name(NOVA_STATUS_OK)) == "NOVA_STATUS_OK");
  assert(std::string(nova_status_code_name(NOVA_STATUS_INVALID_ARGUMENT)) == "NOVA_STATUS_INVALID_ARGUMENT");

  nova::ClientConfig cpp_cfg;
  cpp_cfg.host = "127.0.0.1";
  cpp_cfg.port = 8787;
  const auto c_cfg = cpp_cfg.to_c();
  assert(std::string(c_cfg.host) == "127.0.0.1");
  assert(c_cfg.port == 8787);

  nova_response invalid = nova_tool_call(&c_cfg, "", "{}");
  assert(invalid.status == NOVA_STATUS_INVALID_ARGUMENT);
  nova_response_free(&invalid);

  std::cout << "NOVA native client offline tests passed\n";
  return 0;
}
