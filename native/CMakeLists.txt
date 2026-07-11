cmake_minimum_required(VERSION 3.16)
project(nova_native_interface VERSION 0.1.0 LANGUAGES C CXX)

option(NOVA_NATIVE_BUILD_EXAMPLES "Build NOVA native examples" ON)
option(NOVA_NATIVE_BUILD_TESTS "Build NOVA native tests" ON)

add_library(nova_native STATIC
  src/nova.c
  src/nova_runtime.cpp
)

add_library(nova::native ALIAS nova_native)

target_compile_features(nova_native PUBLIC c_std_11 cxx_std_17)
target_include_directories(nova_native
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
)

if(MSVC)
  target_compile_options(nova_native PRIVATE /W4 /permissive-)
else()
  target_compile_options(nova_native PRIVATE -Wall -Wextra -Wpedantic)
endif()

if(NOVA_NATIVE_BUILD_EXAMPLES)
  add_executable(nova_c_example examples/c_basic.c)
  target_link_libraries(nova_c_example PRIVATE nova::native)

  add_executable(nova_cpp_example examples/cpp_basic.cpp)
  target_link_libraries(nova_cpp_example PRIVATE nova::native)
endif()

if(NOVA_NATIVE_BUILD_TESTS)
  enable_testing()
  add_executable(nova_native_tests tests/test_nova_native.cpp)
  target_link_libraries(nova_native_tests PRIVATE nova::native)
  add_test(NAME nova_native_tests COMMAND nova_native_tests)
endif()
