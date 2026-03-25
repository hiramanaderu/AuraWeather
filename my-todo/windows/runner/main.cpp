#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "utils.h"
#include "window_configuration.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // 将输出附加到父控制台（如果有）
  if (AttachConsole(ATTACH_PARENT_PROCESS) || AllocConsole()) {
    freopen("CONOUT$", "w", stdout);
    freopen("CONOUT$", "w", stderr);
  }

  // 将Windows DPI设置为每监视器感知
  SetProcessDpiAwarenessContext(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2);

  // 初始化COM
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  // 创建窗口配置
  WindowConfiguration window_config;
  window_config.title = L"天气穿搭助手";
  window_config.width = 1280;
  window_config.height = 720;
  window_config.min_width = 800;
  window_config.min_height = 600;

  // 创建Flutter项目配置
  flutter::DartProject project(L"data");

  // 创建窗口
  FlutterWindow window(window_config, project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(window_config.width, window_config.height);
  if (!window.Create(L"天气穿搭助手", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  // 运行消息循环
  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
