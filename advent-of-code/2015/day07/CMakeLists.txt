cmake_minimum_required(VERSION 3.0.0)
project(day07 VERSION 0.1.0)

include(CTest)
enable_testing()

set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(MSVC)
    # cl and clang-cl accept /W4 (but -Weverything will override in clang-cl).
    string(REGEX REPLACE /W[123] /W4 CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})

    # cl and clang-cl accept /permissive- for stricter conformance.
    add_compile_options(/permissive-)

    # cl and clang-cl warn about strerror (but strerror_s is nonportable).
    add_compile_definitions(_CRT_SECURE_NO_WARNINGS)
else()
    # gcc/g++ and clang/clang++ require comparably strict conformance to
    # /permissive- unless -fpermissive is passed. But they accept -pedantic
    # for even more conformance warnings, and -pedantic-errors for errors.
    add_compile_options(-pedantic-errors)
endif()

if(${CMAKE_CXX_COMPILER_ID} STREQUAL "Clang")
    # Clang accepts -Weverything with both clang/clang++ and clang-cl.
    # We will keep all but a few of the warnings that -Weverything enables.
    add_compile_options(
        -Weverything
        -Wno-c++98-compat
        -Wno-padded
    )
elseif(MSVC)
    # cl but not clang-cl accepts /Za to reject Microsoft extensions.
    add_compile_options(/Za)

    # cl but not clang-cl accepts /analyze for static analysis (default rules).
    add_compile_options(/analyze)
else()
    # Enable most warnings.
    add_compile_options(-Wall -Wextra)
endif()

add_executable(day07a day07a.cpp)
add_executable(day07b day07b.cpp)
add_executable(day07a-variant day07a-variant.cpp)
add_executable(day07b-variant day07b-variant.cpp)
add_executable(day07a-function day07a-function.cpp)
# add_executable(day07b-function day07b-function.cpp)

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)
