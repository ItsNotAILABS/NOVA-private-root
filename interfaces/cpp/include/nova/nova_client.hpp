#pragma once

#include "nova/nova_client.h"

#include <stdexcept>
#include <string>
#include <utility>

namespace nova {

class Error : public std::runtime_error {
public:
  explicit Error(const std::string& message) : std::runtime_error(message) {}
};

struct Config {
  std::string host = "127.0.0.1";
  unsigned short port = 8787;
  int timeout_ms = 5000;
  size_t max_response_bytes = 1024 * 1024;

  nova_client_config to_c_config() const {
    nova_client_config c{};
    c.host = host.c_str();
    c.port = port;
    c.timeout_ms = timeout_ms;
    c.max_response_bytes = max_response_bytes;
    return c;
  }
};

class Response {
public:
  explicit Response(nova_response response) : response_(response) {}
  Response(const Response&) = delete;
  Response& operator=(const Response&) = delete;

  Response(Response&& other) noexcept : response_(other.response_) {
    other.response_.body = nullptr;
    other.response_.body_len = 0;
  }

  Response& operator=(Response&& other) noexcept {
    if (this != &other) {
      nova_response_free(&response_);
      response_ = other.response_;
      other.response_.body = nullptr;
      other.response_.body_len = 0;
    }
    return *this;
  }

  ~Response() { nova_response_free(&response_); }

  bool ok() const { return response_.status == NOVA_STATUS_OK; }
  nova_status_code status() const { return response_.status; }
  const char* status_name() const { return nova_status_code_name(response_.status); }
  std::string body() const { return response_.body ? std::string(response_.body, response_.body_len) : std::string(); }
  std::string error() const { return response_.error; }

  void throw_if_error() const {
    if (!ok()) {
      throw Error(std::string(status_name()) + ": " + error());
    }
  }

private:
  nova_response response_{};
};

class Client {
public:
  explicit Client(Config config = {}) : config_(std::move(config)) {}

  Response tools_list() const {
    auto c = config_.to_c_config();
    return Response(nova_tools_list(&c));
  }

  Response call(const std::string& tool_name, const std::string& arguments_json = "{}") const {
    auto c = config_.to_c_config();
    return Response(nova_tool_call(&c, tool_name.c_str(), arguments_json.c_str()));
  }

private:
  Config config_;
};

} // namespace nova
