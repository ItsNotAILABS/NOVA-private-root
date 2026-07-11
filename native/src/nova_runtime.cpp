#include "nova_runtime.hpp"

#include <algorithm>
#include <cstdio>
#include <cstring>
#include <functional>
#include <sstream>

int nova_copy_string(const std::string& value, char* buffer, size_t buffer_size, size_t* out_size) {
    if (out_size != nullptr) {
        *out_size = value.size();
    }
    if (buffer == nullptr || buffer_size == 0) {
        return NOVA_ERR_INVALID_ARGUMENT;
    }
    if (buffer_size <= value.size()) {
        const size_t copy_size = buffer_size - 1;
        if (copy_size > 0) {
            std::memcpy(buffer, value.data(), copy_size);
        }
        buffer[copy_size] = '\0';
        return NOVA_ERR_BUFFER_TOO_SMALL;
    }
    std::memcpy(buffer, value.data(), value.size());
    buffer[value.size()] = '\0';
    return NOVA_OK;
}

std::string nova_make_runtime_id(const nova_config_t& config) {
    const std::string instance = config.instance_name != nullptr ? config.instance_name : "nova-native";
    const std::string operator_id = config.operator_id != nullptr ? config.operator_id : "local-operator";
    const std::size_t hash = std::hash<std::string>{}(instance + ":" + operator_id);
    char buffer[64]{};
    std::snprintf(buffer, sizeof(buffer), "nova-%08zx", hash & 0xffffffffu);
    return buffer;
}

std::string nova_make_status_json(const nova_runtime& runtime) {
    std::ostringstream out;
    out << "{";
    out << "\"ok\":true,";
    out << "\"runtime_id\":\"" << runtime.runtime_id << "\",";
    out << "\"instance_name\":\"" << runtime.instance_name << "\",";
    out << "\"operator_id\":\"" << runtime.operator_id << "\",";
    out << "\"sequence\":" << runtime.sequence << ",";
    out << "\"abi_version\":" << NOVA_ABI_VERSION << ",";
    out << "\"mode\":\"native-local-interface\"";
    out << "}";
    return out.str();
}

std::string nova_route_for_packet(const nova_packet_t& packet) {
    if (packet.route_hint != nullptr && packet.route_hint[0] != '\0') {
        return packet.route_hint;
    }
    const std::string intent = packet.intent != nullptr ? packet.intent : "";
    if (intent.find("status") != std::string::npos) {
        return "status";
    }
    if (intent.find("memory") != std::string::npos) {
        return "memory";
    }
    if (intent.find("agent") != std::string::npos) {
        return "agent";
    }
    return "native";
}
