#include <cassert>
#include <cstring>
#include <string>

#include "nova/nova.h"
#include "nova/nova.hpp"

static void test_c_abi() {
    nova_config_t config;
    nova_config_init(&config);
    config.instance_name = "test-c";
    config.operator_id = "test-operator";

    nova_runtime_t* runtime = nullptr;
    assert(nova_runtime_create(&config, &runtime) == NOVA_OK);
    assert(runtime != nullptr);

    char status[512]{};
    size_t status_size = 0;
    assert(nova_runtime_status(runtime, status, sizeof(status), &status_size) == NOVA_OK);
    assert(std::string(status).find("test-c") != std::string::npos);

    nova_packet_t packet{};
    packet.intent = "status test";
    packet.payload_json = "{\"ok\":true}";
    packet.route_hint = "test-route";

    nova_receipt_t receipt{};
    assert(nova_runtime_submit(runtime, &packet, &receipt) == NOVA_OK);
    assert(receipt.sequence == 1);
    assert(std::strcmp(receipt.route, "test-route") == 0);

    nova_runtime_destroy(runtime);
}

static void test_cpp_wrapper() {
    nova::Config config;
    config.instance_name = "test-cpp";
    config.operator_id = "test-operator";
    nova::Runtime runtime(config);
    assert(runtime.status().find("test-cpp") != std::string::npos);

    nova::Packet packet;
    packet.intent = "cpp status test";
    packet.payload_json = "{\"ok\":true}";
    packet.route_hint = "cpp-test";

    const nova_receipt_t receipt = runtime.submit(packet);
    assert(receipt.sequence == 1);
    assert(std::strcmp(receipt.route, "cpp-test") == 0);
}

int main() {
    test_c_abi();
    test_cpp_wrapper();
    return 0;
}
