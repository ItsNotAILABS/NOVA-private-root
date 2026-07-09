#ifndef NOVA_NATIVE_RUNTIME_INTERNAL_HPP
#define NOVA_NATIVE_RUNTIME_INTERNAL_HPP

#include <cstdint>
#include <string>

#include "nova/nova.h"

struct nova_runtime {
    std::string runtime_id;
    std::string instance_name;
    std::string operator_id;
    std::string last_error;
    uint64_t sequence = 0;
    uint32_t flags = 0;
};

int nova_copy_string(const std::string& value, char* buffer, size_t buffer_size, size_t* out_size);
std::string nova_make_runtime_id(const nova_config_t& config);
std::string nova_make_status_json(const nova_runtime& runtime);
std::string nova_route_for_packet(const nova_packet_t& packet);

#endif  // NOVA_NATIVE_RUNTIME_INTERNAL_HPP
