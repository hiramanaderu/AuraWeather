#ifndef RUNNER_UTILS_H_
#define RUNNER_UTILS_H_

#include <string>
#include <vector>

#include <windows.h>

std::string Utf8FromUtf16(const wchar_t* utf16_string);

void UpdateTheme(HWND window);

#endif  // RUNNER_UTILS_H_
