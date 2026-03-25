cmake_minimum_required(VERSION 3.14)
project(weather_assistant LANGUAGES CXX)

set(BINARY_NAME "weather_assistant")

cmake_policy(VERSION 3.14...3.25)

set(CMAKE_INSTALL_RPATH "\$ORIGIN")

# Flutter配置
include(flutter/generated_plugins.cmake)

set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")

# 应用程序定义
add_executable(${BINARY_NAME} WIN32
  "flutter/generated_plugin_registrant.cc"
  "flutter/generated_plugins.cmake"
  "runner/main.cpp"
  "runner/resource.h"
  "runner/resources.rc"
  "runner/runner.exe.manifest"
  "runner/Runner.rc"
  "runner/utils.cpp"
  "runner/utils.h"
  "runner/win32_window.cpp"
  "runner/win32_window.h"
  "runner/window_configuration.cpp"
  "runner/window_configuration.h"
)

# 应用标识
set_target_properties(${BINARY_NAME} PROPERTIES
  CXX_STANDARD 17
  CXX_STANDARD_REQUIRED ON
  VS_GLOBAL_KEYWORD "Win32Proj"
)

target_compile_definitions(${BINARY_NAME} PRIVATE
  "NOMINMAX"
  "_UNICODE"
  "UNICODE"
)

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE "dwmapi.lib")

# Flutter资产管理
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")
include(${FLUTTER_MANAGED_DIR}/generated_plugins.cmake)

# 安装
set(BUILD_BUNDLE_DIR "$<TARGET_FILE_DIR:${BINARY_NAME}>")
set(CMAKE_VS_INCLUDE_INSTALL_TO_DEFAULT_BUILD 1)
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${BUILD_BUNDLE_DIR}" CACHE PATH "..." FORCE)
endif()

set(INSTALL_BUNDLE_DATA_DIR "${CMAKE_INSTALL_PREFIX}/data")
set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}")

install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}"
  COMPONENT Runtime)

install(FILES "${FLUTTER_ICU_DATA_FILE}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}"
  COMPONENT Runtime)

install(FILES "${FLUTTER_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime)

if(PLUGIN_BUNDLED_LIBRARIES)
  install(FILES "${PLUGIN_BUNDLED_LIBRARIES}"
    DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
    COMPONENT Runtime)
endif()

# 复制Flutter资产
install(CODE "
  file(REMOVE_RECURSE \"${INSTALL_BUNDLE_DATA_DIR}/flutter_assets\")
  file(COPY \"${FLUTTER_ASSET_DIR}\" DESTINATION \"${INSTALL_BUNDLE_DATA_DIR}\")
" COMPONENT Runtime)

# 复制应用资产
install(CODE "
  file(REMOVE_RECURSE \"${INSTALL_BUNDLE_DATA_DIR}/\")
  file(COPY \"${CMAKE_CURRENT_SOURCE_DIR}/../build/windows/x64/runner/Release/data/flutter_assets\"
    DESTINATION \"${INSTALL_BUNDLE_DATA_DIR}\")
" COMPONENT Runtime)
