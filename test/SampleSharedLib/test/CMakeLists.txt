cmake_minimum_required(VERSION 3.8 FATAL_ERROR)
project(edge_streaming LANGUAGES CXX CUDA)

option(CUDA_USE_STATIC_CUDA_RUNTIME OFF)

set(CMAKE_BUILD_TYPE "Release")
set(OpenGL_GL_PREFERENCE  GLVND)
add_definitions("-DENABLE_SSE")

set(CMAKE_CXX_FLAGS "-std=c++17 -O3 -pthread -Wall -Ofast -Wfatal-errors -D_MWAITXINTRIN_H_INCLUDED")

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

message(STATUS "Gstreamer source: ${GSTREAMER_INCLUDE_DIR}")
include_directories(
    /usr/local/include/
    )

link_directories(/usr/local/cuda/lib64)
link_directories(/usr/local/lib/)
link_directories(/usr/lib/aarch64-linux-gnu/tegra) ## TensorRT for edge are in here
link_directories(${GSTLIBS_LIBRARY_DIRS})

add_executable(${PROJECT_NAME}
    main.cpp    
    )

target_link_libraries(${PROJECT_NAME}
    sample_lib
)
        
