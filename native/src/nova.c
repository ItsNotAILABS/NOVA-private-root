#include "nova/nova.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef __cplusplus
extern "C" {
#endif

struct nova_runtime {
    char runtime_id[64];
    char instance_name[128];
    char operator_id[128];
    char last_error[256];
    uint64_t sequence;
    uint32_t flags;
};

static void nova_write_text(char* dst, size_t dst_size, const char* value) {
    if (dst == NULL || dst_size == 0) {
        return;
    }
    if (value == NULL) {
        value = "";
    }
#if defined(_MSC_VER)
    strncpy_s(dst, dst_size, value, _TRUNCATE);
#else
    snprintf(dst, dst_size, "%s", value);
#endif
}

static int nova_copy_text(const char* value, char* buffer, size_t buffer_size, size_t* out_size) {
    const size_t length = value == NULL ? 0 : strlen(value);
    if (out_size != NULL) {
        *out_size = length;
    }
    if (buffer == NULL || buffer_size == 0) {
        return NOVA_ERR_INVALID_ARGUMENT;
    }
    if (buffer_size <= length) {
        const size_t copy_size = buffer_size - 1;
        if (copy_size > 0 && value != NULL) {
            memcpy(buffer, value, copy_size);
        }
        buffer[copy_size] = '\0';
        return NOVA_ERR_BUFFER_TOO_SMALL;
    }
    if (length > 0 && value != NULL) {
        memcpy(buffer, value, length);
    }
    buffer[length] = '\0';
    return NOVA_OK;
}

const char* nova_version(void) {
    return "nova-native/0.1.0 abi/1";
}

const char* nova_status_message(int code) {
    switch (code) {
        case NOVA_OK: return "ok";
        case NOVA_ERR_INVALID_ARGUMENT: return "invalid argument";
        case NOVA_ERR_BUFFER_TOO_SMALL: return "buffer too small";
        case NOVA_ERR_NOT_INITIALIZED: return "runtime not initialized";
        case NOVA_ERR_INTERNAL: return "internal error";
        default: return "unknown error";
    }
}

void nova_config_init(nova_config_t* config) {
    if (config == NULL) {
        return;
    }
    config->abi_version = NOVA_ABI_VERSION;
    config->instance_name = "nova-native";
    config->operator_id = "local-operator";
    config->flags = 0;
}

int nova_runtime_create(const nova_config_t* config, nova_runtime_t** out_runtime) {
    if (out_runtime == NULL) {
        return NOVA_ERR_INVALID_ARGUMENT;
    }
    *out_runtime = NULL;
    nova_config_t local;
    nova_config_init(&local);
    if (config != NULL) {
        local = *config;
    }
    if (local.abi_version != NOVA_ABI_VERSION) {
        return NOVA_ERR_INVALID_ARGUMENT;
    }
    nova_runtime_t* runtime = (nova_runtime_t*)calloc(1, sizeof(nova_runtime_t));
    if (runtime == NULL) {
        return NOVA_ERR_INTERNAL;
    }
    nova_write_text(runtime->instance_name, sizeof(runtime->instance_name), local.instance_name);
    nova_write_text(runtime->operator_id, sizeof(runtime->operator_id), local.operator_id);
    runtime->flags = local.flags;
    runtime->sequence = 0;
    snprintf(runtime->runtime_id, sizeof(runtime->runtime_id), "nova-%08x", (unsigned)((uintptr_t)runtime & 0xffffffffu));
    nova_write_text(runtime->last_error, sizeof(runtime->last_error), "ok");
    *out_runtime = runtime;
    return NOVA_OK;
}

void nova_runtime_destroy(nova_runtime_t* runtime) {
    free(runtime);
}

int nova_runtime_status(nova_runtime_t* runtime, char* buffer, size_t buffer_size, size_t* out_size) {
    if (runtime == NULL) {
        return NOVA_ERR_NOT_INITIALIZED;
    }
    char status[512];
    snprintf(status, sizeof(status), "{\"ok\":true,\"runtime_id\":\"%s\",\"instance_name\":\"%s\",\"operator_id\":\"%s\",\"sequence\":%llu,\"abi_version\":%u,\"mode\":\"native-local-interface\"}", runtime->runtime_id, runtime->instance_name, runtime->operator_id, (unsigned long long)runtime->sequence, (unsigned)NOVA_ABI_VERSION);
    return nova_copy_text(status, buffer, buffer_size, out_size);
}

int nova_runtime_submit(nova_runtime_t* runtime, const nova_packet_t* packet, nova_receipt_t* out_receipt) {
    if (runtime == NULL) {
        return NOVA_ERR_NOT_INITIALIZED;
    }
    if (packet == NULL || packet->intent == NULL || out_receipt == NULL) {
        nova_write_text(runtime->last_error, sizeof(runtime->last_error), "packet and receipt are required");
        return NOVA_ERR_INVALID_ARGUMENT;
    }
    memset(out_receipt, 0, sizeof(*out_receipt));
    runtime->sequence += 1;
    out_receipt->sequence = runtime->sequence;
    out_receipt->status = NOVA_OK;
    nova_write_text(out_receipt->runtime_id, sizeof(out_receipt->runtime_id), runtime->runtime_id);
    nova_write_text(out_receipt->route, sizeof(out_receipt->route), packet->route_hint != NULL && packet->route_hint[0] != '\0' ? packet->route_hint : "native");
    snprintf(out_receipt->message, sizeof(out_receipt->message), "accepted intent='%s' payload_bytes=%u", packet->intent, (unsigned)(packet->payload_json == NULL ? 0 : strlen(packet->payload_json)));
    nova_write_text(runtime->last_error, sizeof(runtime->last_error), "ok");
    return NOVA_OK;
}

int nova_runtime_last_error(nova_runtime_t* runtime, char* buffer, size_t buffer_size, size_t* out_size) {
    if (runtime == NULL) {
        return NOVA_ERR_NOT_INITIALIZED;
    }
    return nova_copy_text(runtime->last_error, buffer, buffer_size, out_size);
}

#ifdef __cplusplus
}
#endif
