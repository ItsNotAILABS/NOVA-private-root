cmake_minimum_required(VERSION 3.16)
project(nova_native_client VERSION 0.1.0 LANGUAGES CXX)

option(NOVA_NATIVE_BUILD_TESTS "Build NOVA native client tests" ON)
option(NOVA_NATIVE_BUILD_EXAMPLES "Build NOVA native client examples" ON)

add_library(nova_native_client STATIC
  src/nova_client.cpp
)

target_include_directories(nova_native_client
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
)

target_compile_features(nova_native_client PUBLIC cxx_std_17)

if(WIN32)
  target_link_libraries(nova_native_client PUBLIC ws2_32)
endif()

if(NOVA_NATIVE_BUILD_EXAMPLES)
  add_executable(nova_tools_demo examples/nova_tools_demo.cpp)
  target_link_libraries(nova_tools_demo PRIVATE nova_native_client)
endif()

if(NOVA_NATIVE_BUILD_TESTS)
  enable_testing()
  add_executable(nova_client_offline_test tests/test_nova_client_offline.cpp)
  target_link_libraries(nova_client_offline_test PRIVATE nova_native_client)
  add_test(NAME nova_client_offline_test COMMAND nova_client_offline_test)
endif()
