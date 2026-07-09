#include "nova/nova_client.h"

#include <algorithm>
#include <cstring>
#include <sstream>
#include <string>
#include <vector>

#if defined(_WIN32)
  #ifndef NOMINMAX
    #define NOMINMAX
  #endif
  #include <winsock2.h>
  #include <ws2tcpip.h>
  using nova_socket_t = SOCKET;
  static constexpr nova_socket_t NOVA_INVALID_SOCKET = INVALID_SOCKET;
  static void nova_close_socket(nova_socket_t s) { closesocket(s); }
#else
  #include <arpa/inet.h>
  #include <netdb.h>
  #include <sys/socket.h>
  #include <sys/types.h>
  #include <unistd.h>
  using nova_socket_t = int;
  static constexpr nova_socket_t NOVA_INVALID_SOCKET = -1;
  static void nova_close_socket(nova_socket_t s) { close(s); }
#endif

namespace {

nova_response make_response(nova_status_code code, const char* message) {
  nova_response r{};
  r.status = code;
  if (message) {
    std::snprintf(r.error, sizeof(r.error), "%s", message);
  }
  return r;
}

std::string json_escape(const char* input) {
  std::string out;
  if (!input) return out;
  for (const unsigned char c : std::string(input)) {
    switch (c) {
      case '\\': out += "\\\\"; break;
      case '"': out += "\\\""; break;
      case '\n': out += "\\n"; break;
      case '\r': out += "\\r"; break;
      case '\t': out += "\\t"; break;
      default:
        if (c < 0x20) {
          char buf[8];
          std::snprintf(buf, sizeof(buf), "\\u%04x", c);
          out += buf;
        } else {
          out += static_cast<char>(c);
        }
    }
  }
  return out;
}

bool looks_like_json_object(const char* s) {
  if (!s) return false;
  while (*s == ' ' || *s == '\t' || *s == '\r' || *s == '\n') ++s;
  return *s == '{';
}

std::string build_rpc_body(const char* method, const std::string& params) {
  std::ostringstream os;
  os << "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"" << method << "\"";
  if (!params.empty()) os << ",\"params\":" << params;
  os << "}";
  return os.str();
}

nova_status_code copy_body(nova_response* response, const std::string& body) {
  response->body = static_cast<char*>(std::malloc(body.size() + 1));
  if (!response->body) return NOVA_STATUS_ALLOCATION_ERROR;
  std::memcpy(response->body, body.data(), body.size());
  response->body[body.size()] = '\0';
  response->body_len = body.size();
  response->status = NOVA_STATUS_OK;
  return NOVA_STATUS_OK;
}

nova_response post_json(const nova_client_config* config, const std::string& body) {
  if (!config || !config->host || config->port == 0) {
    return make_response(NOVA_STATUS_INVALID_ARGUMENT, "invalid host or port");
  }

#if defined(_WIN32)
  WSADATA wsa{};
  if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0) {
    return make_response(NOVA_STATUS_SOCKET_ERROR, "WSAStartup failed");
  }
#endif

  addrinfo hints{};
  hints.ai_family = AF_UNSPEC;
  hints.ai_socktype = SOCK_STREAM;

  addrinfo* results = nullptr;
  const std::string port = std::to_string(config->port);
  if (getaddrinfo(config->host, port.c_str(), &hints, &results) != 0 || !results) {
#if defined(_WIN32)
    WSACleanup();
#endif
    return make_response(NOVA_STATUS_SOCKET_ERROR, "getaddrinfo failed");
  }

  nova_socket_t sock = NOVA_INVALID_SOCKET;
  for (addrinfo* it = results; it; it = it->ai_next) {
    sock = static_cast<nova_socket_t>(socket(it->ai_family, it->ai_socktype, it->ai_protocol));
    if (sock == NOVA_INVALID_SOCKET) continue;
    if (connect(sock, it->ai_addr, static_cast<int>(it->ai_addrlen)) == 0) break;
    nova_close_socket(sock);
    sock = NOVA_INVALID_SOCKET;
  }
  freeaddrinfo(results);

  if (sock == NOVA_INVALID_SOCKET) {
#if defined(_WIN32)
    WSACleanup();
#endif
    return make_response(NOVA_STATUS_SOCKET_ERROR, "connect failed");
  }

  std::ostringstream req;
  req << "POST / HTTP/1.1\r\n"
      << "Host: " << config->host << ":" << config->port << "\r\n"
      << "Content-Type: application/json\r\n"
      << "Connection: close\r\n"
      << "Content-Length: " << body.size() << "\r\n\r\n"
      << body;

  const std::string raw = req.str();
  size_t sent = 0;
  while (sent < raw.size()) {
    const int n = send(sock, raw.data() + sent, static_cast<int>(raw.size() - sent), 0);
    if (n <= 0) {
      nova_close_socket(sock);
#if defined(_WIN32)
      WSACleanup();
#endif
      return make_response(NOVA_STATUS_SOCKET_ERROR, "send failed");
    }
    sent += static_cast<size_t>(n);
  }

  const size_t max_bytes = config->max_response_bytes ? config->max_response_bytes : 4 * 1024 * 1024;
  std::string response;
  std::vector<char> buffer(8192);
  for (;;) {
    const int n = recv(sock, buffer.data(), static_cast<int>(buffer.size()), 0);
    if (n == 0) break;
    if (n < 0) {
      nova_close_socket(sock);
#if defined(_WIN32)
      WSACleanup();
#endif
      return make_response(NOVA_STATUS_SOCKET_ERROR, "recv failed");
    }
    response.append(buffer.data(), static_cast<size_t>(n));
    if (response.size() > max_bytes) {
      nova_close_socket(sock);
#if defined(_WIN32)
      WSACleanup();
#endif
      return make_response(NOVA_STATUS_RESPONSE_TOO_LARGE, "response exceeded limit");
    }
  }

  nova_close_socket(sock);
#if defined(_WIN32)
  WSACleanup();
#endif

  const auto header_end = response.find("\r\n\r\n");
  if (header_end == std::string::npos) {
    return make_response(NOVA_STATUS_PROTOCOL_ERROR, "missing HTTP header terminator");
  }

  const std::string payload = response.substr(header_end + 4);
  nova_response out{};
  const nova_status_code copied = copy_body(&out, payload);
  if (copied != NOVA_STATUS_OK) return make_response(copied, "allocation failed");
  return out;
}

} // namespace

nova_client_config nova_default_config(void) {
  nova_client_config cfg{};
  cfg.host = "127.0.0.1";
  cfg.port = 8787;
  cfg.timeout_ms = 5000;
  cfg.max_response_bytes = 4 * 1024 * 1024;
  return cfg;
}

nova_response nova_tools_list(const nova_client_config* config) {
  return post_json(config, build_rpc_body("tools/list", ""));
}

nova_response nova_tool_call(const nova_client_config* config, const char* tool_name, const char* arguments_json) {
  if (!tool_name || !*tool_name) return make_response(NOVA_STATUS_INVALID_ARGUMENT, "tool_name is required");
  const std::string args = looks_like_json_object(arguments_json) ? arguments_json : "{}";
  std::ostringstream params;
  params << "{\"name\":\"" << json_escape(tool_name) << "\",\"arguments\":" << args << "}";
  return post_json(config, build_rpc_body("tools/call", params.str()));
}

void nova_response_free(nova_response* response) {
  if (!response) return;
  std::free(response->body);
  response->body = nullptr;
  response->body_len = 0;
}

const char* nova_status_code_name(nova_status_code code) {
  switch (code) {
    case NOVA_STATUS_OK: return "NOVA_STATUS_OK";
    case NOVA_STATUS_INVALID_ARGUMENT: return "NOVA_STATUS_INVALID_ARGUMENT";
    case NOVA_STATUS_SOCKET_ERROR: return "NOVA_STATUS_SOCKET_ERROR";
    case NOVA_STATUS_PROTOCOL_ERROR: return "NOVA_STATUS_PROTOCOL_ERROR";
    case NOVA_STATUS_ALLOCATION_ERROR: return "NOVA_STATUS_ALLOCATION_ERROR";
    case NOVA_STATUS_RESPONSE_TOO_LARGE: return "NOVA_STATUS_RESPONSE_TOO_LARGE";
    default: return "NOVA_STATUS_UNKNOWN";
  }
}
