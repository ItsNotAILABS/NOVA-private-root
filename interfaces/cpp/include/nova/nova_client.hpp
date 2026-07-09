#pragma once

#include "nova/nova_client.h"

#include <cstddef>
#include <stdexcept>
#include <string>
#include <utility>

namespace nova {

class Error final : public std::runtime_error {
public:
  explicit Error(const std::string& message) : std::runtime_error(message) {}
};

struct ClientConfig final {
  std::string host = "127.0.0.1";
  unsigned short port = 8787;
  int timeout_ms = 5000;
  std::size_t max_response_bytes = 4 * 1024 * 1024;

  nova_client_config to_c() const {
    nova_client_config cfg{};
    cfg.host = host.c_str();
    cfg.port = port;
    cfg.timeout_ms = timeout_ms;
    cfg.max_response_bytes = max_response_bytes;
    return cfg;
  }
};

class Response final {
public:
  Response() = default;
  explicit Response(nova_response response) : response_(response) {}
  Response(const Response&) = delete;
  Response& operator=(const Response&) = delete;

  Response(Response&& other) noexcept : response_(other.response_) {
    other.response_ = nova_response{};
  }

  Response& operator=(Response&& other) noexcept {
    if (this != &other) {
      nova_response_free(&response_);
      response_ = other.response_;
      other.response_ = nova_response{};
    }
    return *this;
  }

  ~Response() { nova_response_free(&response_); }

  bool ok() const { return response_.status == NOVA_STATUS_OK; }
  nova_status_code status() const { return response_.status; }
  std::string body() const { return response_.body ? std::string(response_.body, response_.body_len) : std::string(); }
  std::string error() const { return response_.error; }

private:
  nova_response response_{};
};

class Client final {
public:
  Client() = default;
  explicit Client(ClientConfig config) : config_(std::move(config)) {}

  Response tools_list() const {
    const auto cfg = config_.to_c();
    return Response(nova_tools_list(&cfg));
  }

  Response tool_call(const std::string& tool_name, const std::string& arguments_json = "{}") const {
    const auto cfg = config_.to_c();
    return Response(nova_tool_call(&cfg, tool_name.c_str(), arguments_json.c_str()));
  }

private:
  ClientConfig config_{};
};

}  // namespace nova
