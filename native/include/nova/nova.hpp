#ifndef NOVA_NATIVE_NOVA_HPP
#define NOVA_NATIVE_NOVA_HPP

#include <stdexcept>
#include <string>
#include <utility>

#include "nova/nova.h"

namespace nova {

class Error : public std::runtime_error {
public:
    explicit Error(int code)
        : std::runtime_error(nova_status_message(code)), code_(code) {}

    Error(int code, std::string message)
        : std::runtime_error(std::move(message)), code_(code) {}

    int code() const noexcept { return code_; }

private:
    int code_;
};

struct Config {
    std::string instance_name = "nova-native";
    std::string operator_id = "local-operator";
    uint32_t flags = 0;
};

struct Packet {
    std::string intent;
    std::string payload_json = "{}";
    std::string route_hint = "native";
};

class Runtime {
public:
    explicit Runtime(const Config& config = Config{}) {
        nova_config_t raw{};
        nova_config_init(&raw);
        raw.instance_name = config.instance_name.c_str();
        raw.operator_id = config.operator_id.c_str();
        raw.flags = config.flags;
        const int rc = nova_runtime_create(&raw, &runtime_);
        if (rc != NOVA_OK) {
            throw Error(rc);
        }
    }

    ~Runtime() { nova_runtime_destroy(runtime_); }

    Runtime(const Runtime&) = delete;
    Runtime& operator=(const Runtime&) = delete;

    Runtime(Runtime&& other) noexcept : runtime_(other.runtime_) { other.runtime_ = nullptr; }

    Runtime& operator=(Runtime&& other) noexcept {
        if (this != &other) {
            nova_runtime_destroy(runtime_);
            runtime_ = other.runtime_;
            other.runtime_ = nullptr;
        }
        return *this;
    }

    std::string status() const {
        char buffer[512]{};
        size_t out_size = 0;
        const int rc = nova_runtime_status(runtime_, buffer, sizeof(buffer), &out_size);
        if (rc != NOVA_OK) {
            throw Error(rc, last_error());
        }
        return std::string(buffer, out_size);
    }

    nova_receipt_t submit(const Packet& packet) {
        nova_packet_t raw{};
        raw.intent = packet.intent.c_str();
        raw.payload_json = packet.payload_json.c_str();
        raw.route_hint = packet.route_hint.c_str();
        nova_receipt_t receipt{};
        const int rc = nova_runtime_submit(runtime_, &raw, &receipt);
        if (rc != NOVA_OK) {
            throw Error(rc, last_error());
        }
        return receipt;
    }

    std::string last_error() const {
        char buffer[512]{};
        size_t out_size = 0;
        const int rc = nova_runtime_last_error(runtime_, buffer, sizeof(buffer), &out_size);
        if (rc != NOVA_OK) {
            return nova_status_message(rc);
        }
        return std::string(buffer, out_size);
    }

private:
    nova_runtime_t* runtime_ = nullptr;
};

}  // namespace nova

#endif  // NOVA_NATIVE_NOVA_HPP
