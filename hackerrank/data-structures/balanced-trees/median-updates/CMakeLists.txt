cmake_minimum_required(VERSION 3.0.0)
project(MedianUpdates VERSION 0.1.0)

include(CTest)
enable_testing()

set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(MSVC)
    # cl and clang-cl accept /W4 (but -Weverything will override in clang-cl).
    string(REGEX REPLACE /W[123] /W4 CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})

    # cl and clang-cl accept /permissive- for stricter conformance.
    add_compile_options(/permissive-)
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

find_package(absl CONFIG REQUIRED)

add_executable(median-updates-tree median-updates-tree.cpp)
add_executable(median-updates median-updates.cpp)
add_executable(median-updates-tree-absl median-updates-tree-absl.cpp)
add_executable(median-updates-absl median-updates-absl.cpp)

target_link_libraries(median-updates-absl PRIVATE absl::base absl::hash absl::container)

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)
