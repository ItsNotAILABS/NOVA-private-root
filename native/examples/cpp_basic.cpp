#include <iostream>

#include "nova/nova.hpp"

int main() {
    try {
        nova::Config config;
        config.instance_name = "nova-cpp-example";
        config.operator_id = "example-operator";

        nova::Runtime runtime(config);
        std::cout << "status: " << runtime.status() << '\n';

        nova::Packet packet;
        packet.intent = "cpp native status packet";
        packet.payload_json = "{\"source\":\"cpp_basic\"}";
        packet.route_hint = "cpp-example";

        const nova_receipt_t receipt = runtime.submit(packet);
        std::cout << "receipt: sequence=" << receipt.sequence
                  << " route=" << receipt.route
                  << " message=" << receipt.message << '\n';
    } catch (const nova::Error& err) {
        std::cerr << "NOVA error " << err.code() << ": " << err.what() << '\n';
        return 1;
    }
    return 0;
}
