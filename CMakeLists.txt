cmake_minimum_required(VERSION 3.18)
project(dec_enc_lib VERSION 1.0.0 DESCRIPTION "sample demo for lib build with cmake" LANGUAGES CXX CUDA)

option(CUDA_USE_STATIC_CUDA_RUNTIME OFF)

# set(CMAKE_BUILD_TYPE "Release")
set(OpenGL_GL_PREFERENCE  GLVND)
add_definitions("-DENABLE_SSE")

set(CMAKE_CXX_FLAGS "-std=c++17 -O3 -pthread -Wall -Ofast -Wfatal-errors -D_MWAITXINTRIN_H_INCLUDED")

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
add_library(${PROJECT_NAME} SHARED
    src/decoder/NvDecoder.cpp
    src/encoder/NvEncoder.cpp
)

set_target_properties(${PROJECT_NAME} PROPERTIES VERSION ${PROJECT_VERSION})

set(dec_enc_lib_PUBLIC_HEADERS
    "third_party/cuviddec.h"
    "third_party/nvcuvid.h"
    "third_party/nvEncodeAPI.h"
    "include/decoder/NvDecoder.h"
    )

set_target_properties(${PROJECT_NAME} PROPERTIES PUBLIC_HEADER 
    "${dec_enc_lib_PUBLIC_HEADERS}"
)

set(dec_enc_lib_HEADERS_FOLDER
    "third_party"
    "include/decoder"
    )

include_directories(
    ${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES}
)

link_directories(/usr/local/cuda/lib64)

target_include_directories(${PROJECT_NAME} PRIVATE ${dec_enc_lib_HEADERS_FOLDER})
target_include_directories(${PROJECT_NAME} PRIVATE src)

target_link_libraries(${PROJECT_NAME}
    cuda
)

install(TARGETS ${PROJECT_NAME}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

configure_file(dec_end_lib.pc.in dec_end_lib.pc @ONLY)

install(FILES ${CMAKE_BINARY_DIR}/dec_end_lib.pc DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/pkgconfig)