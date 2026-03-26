#ifndef RUNNER_WINDOW_CONFIGURATION_H_
#define RUNNER_WINDOW_CONFIGURATION_H_

#include <string>

struct WindowConfiguration {
  std::wstring title;
  int width;
  int height;
  int min_width;
  int min_height;
};

#endif  // RUNNER_WINDOW_CONFIGURATION_H_
