#ifndef RUNNER_WIN32_WINDOW_H_
#define RUNNER_WIN32_WINDOW_H_

#include <windows.h>

#include <functional>
#include <memory>
#include <string>

class Win32Window {
 public:
  struct Point {
    unsigned int x;
    unsigned int y;
    Point(unsigned int x, unsigned int y) : x(x), y(y) {}
  };

  struct Size {
    unsigned int width;
    unsigned int height;
    Size(unsigned int width, unsigned int height)
        : width(width), height(height) {}
  };

  Win32Window();
  virtual ~Win32Window();

  bool Create(const std::wstring& title, const Point& origin, const Size& size);
  void Show();
  void Hide();
  void Close();
  void SetQuitOnClose(bool quit_on_close);
  void Destroy();

  HWND GetHandle() const { return window_handle_; }

  static Win32Window* GetThisFromHandle(HWND const window) noexcept;

 protected:
  virtual bool OnCreate();
  virtual void OnDestroy();

  LRESULT MessageHandler(HWND hwnd, UINT const message, WPARAM const wparam,
                         LPARAM const lparam) noexcept;

 private:
  WNDCLASS RegisterWindowClass();
  
  static LRESULT CALLBACK WndProc(HWND const window, UINT const message,
                                  WPARAM const wparam,
                                  LPARAM const lparam) noexcept;

  int ResizeChildContent();
  void SetChildContent(HWND content);
  RECT GetClientArea();

  HWND window_handle_ = nullptr;
  HWND child_content_ = nullptr;
  bool quit_on_close_ = false;
};

#endif  // RUNNER_WIN32_WINDOW_H_
