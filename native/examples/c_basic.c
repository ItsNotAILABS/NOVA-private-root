#include <stdio.h>

#include "nova/nova.h"

int main(void) {
    nova_config_t config;
    nova_config_init(&config);
    config.instance_name = "nova-c-example";
    config.operator_id = "example-operator";

    nova_runtime_t* runtime = NULL;
    int rc = nova_runtime_create(&config, &runtime);
    if (rc != NOVA_OK) {
        fprintf(stderr, "create failed: %s\n", nova_status_message(rc));
        return 1;
    }

    char status[512];
    size_t status_size = 0;
    rc = nova_runtime_status(runtime, status, sizeof(status), &status_size);
    if (rc != NOVA_OK) {
        fprintf(stderr, "status failed: %s\n", nova_status_message(rc));
        nova_runtime_destroy(runtime);
        return 1;
    }
    printf("status: %s\n", status);

    nova_packet_t packet;
    packet.intent = "native status packet";
    packet.payload_json = "{\"source\":\"c_basic\"}";
    packet.route_hint = "native-example";

    nova_receipt_t receipt;
    rc = nova_runtime_submit(runtime, &packet, &receipt);
    if (rc != NOVA_OK) {
        fprintf(stderr, "submit failed: %s\n", nova_status_message(rc));
        nova_runtime_destroy(runtime);
        return 1;
    }

    printf("receipt: sequence=%llu route=%s message=%s\n",
           (unsigned long long)receipt.sequence,
           receipt.route,
           receipt.message);

    nova_runtime_destroy(runtime);
    return 0;
}
