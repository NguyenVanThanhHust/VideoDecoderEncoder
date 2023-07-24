cmake_minimum_required(VERSION 3.14)
project(sample_lib VERSION 1.0.0 DESCRIPTION "sample demo for lib build with cmake")

add_library(${PROJECT_NAME} SHARED
    src/add.cpp
    src/multiply.cpp
)

set_target_properties(${PROJECT_NAME} PROPERTIES VERSION ${PROJECT_VERSION})

set(SAMPLE_LIB_PUBLIC_HEADERS
    "include/add.h"
    "include/multiply.h"
    )

set_target_properties(${PROJECT_NAME} PROPERTIES PUBLIC_HEADER 
    "${SAMPLE_LIB_PUBLIC_HEADERS}"
)

target_include_directories(${PROJECT_NAME} PRIVATE include)
target_include_directories(${PROJECT_NAME} PRIVATE src)

install(TARGETS ${PROJECT_NAME}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

configure_file(sample_lib.pc.in sample_lib.pc @ONLY)

install(FILES ${CMAKE_BINARY_DIR}/sample_lib.pc DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/pkgconfig)