cmake_minimum_required(VERSION 3.18)
project(decode_video VERSION 1.0.0 DESCRIPTION "sample demo for lib build with cmake" LANGUAGES CXX CUDA)

option(CUDA_USE_STATIC_CUDA_RUNTIME OFF)

# set(CMAKE_BUILD_TYPE "Release")
set(OpenGL_GL_PREFERENCE  GLVND)
add_definitions("-DENABLE_SSE")

set(CMAKE_CXX_FLAGS "-std=c++17 -O3 -pthread -Wall -Ofast -Wfatal-errors -D_MWAITXINTRIN_H_INCLUDED")

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

add_executable(${PROJECT_NAME}
    main.cpp
    )


include_directories(
    ${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES}
    /usr/local/include/
)

link_directories(
    /usr/local/cuda/lib64
    /usr/local/lib/
)

target_link_libraries(${PROJECT_NAME}
    cuda
    /usr/local/lib/libdec_enc_lib.so
)