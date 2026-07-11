#ifndef NOVA_NATIVE_NOVA_H
#define NOVA_NATIVE_NOVA_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#if defined(_WIN32) && defined(NOVA_NATIVE_SHARED)
  #if defined(NOVA_NATIVE_EXPORTS)
    #define NOVA_API __declspec(dllexport)
  #else
    #define NOVA_API __declspec(dllimport)
  #endif
#else
  #define NOVA_API
#endif

#define NOVA_ABI_VERSION 1
#define NOVA_OK 0
#define NOVA_ERR_INVALID_ARGUMENT 1
#define NOVA_ERR_BUFFER_TOO_SMALL 2
#define NOVA_ERR_NOT_INITIALIZED 3
#define NOVA_ERR_INTERNAL 4

typedef struct nova_runtime nova_runtime_t;

typedef struct nova_config {
    uint32_t abi_version;
    const char* instance_name;
    const char* operator_id;
    uint32_t flags;
} nova_config_t;

typedef struct nova_packet {
    const char* intent;
    const char* payload_json;
    const char* route_hint;
} nova_packet_t;

typedef struct nova_receipt {
    uint64_t sequence;
    int status;
    char runtime_id[64];
    char route[64];
    char message[256];
} nova_receipt_t;

NOVA_API const char* nova_version(void);
NOVA_API const char* nova_status_message(int code);

NOVA_API void nova_config_init(nova_config_t* config);
NOVA_API int nova_runtime_create(const nova_config_t* config, nova_runtime_t** out_runtime);
NOVA_API void nova_runtime_destroy(nova_runtime_t* runtime);

NOVA_API int nova_runtime_status(nova_runtime_t* runtime, char* buffer, size_t buffer_size, size_t* out_size);
NOVA_API int nova_runtime_submit(nova_runtime_t* runtime, const nova_packet_t* packet, nova_receipt_t* out_receipt);
NOVA_API int nova_runtime_last_error(nova_runtime_t* runtime, char* buffer, size_t buffer_size, size_t* out_size);

#ifdef __cplusplus
}
#endif

#endif /* NOVA_NATIVE_NOVA_H */
