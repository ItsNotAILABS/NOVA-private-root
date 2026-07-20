#ifndef NOVA_CLIENT_H
#define NOVA_CLIENT_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

#if defined(_WIN32)
  #if defined(NOVA_CLIENT_BUILD_DLL)
    #define NOVA_API __declspec(dllexport)
  #elif defined(NOVA_CLIENT_USE_DLL)
    #define NOVA_API __declspec(dllimport)
  #else
    #define NOVA_API
  #endif
#else
  #define NOVA_API
#endif

typedef enum nova_status_code {
  NOVA_STATUS_OK = 0,
  NOVA_STATUS_INVALID_ARGUMENT = 1,
  NOVA_STATUS_SOCKET_ERROR = 2,
  NOVA_STATUS_PROTOCOL_ERROR = 3,
  NOVA_STATUS_ALLOCATION_ERROR = 4,
  NOVA_STATUS_RESPONSE_TOO_LARGE = 5
} nova_status_code;

typedef struct nova_client_config {
  const char* host;
  unsigned short port;
  int timeout_ms;
  size_t max_response_bytes;
} nova_client_config;

typedef struct nova_response {
  nova_status_code status;
  char* body;
  size_t body_len;
  char error[256];
} nova_response;

NOVA_API nova_client_config nova_default_config(void);
NOVA_API nova_response nova_tools_list(const nova_client_config* config);
NOVA_API nova_response nova_tool_call(const nova_client_config* config, const char* tool_name, const char* arguments_json);
NOVA_API void nova_response_free(nova_response* response);
NOVA_API const char* nova_status_code_name(nova_status_code code);

#ifdef __cplusplus
}
#endif

#endif
