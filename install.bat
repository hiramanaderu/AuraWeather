@echo off
chcp 65001 >nul

:: 天气穿搭助手 - Windows 一键安装脚本
echo 🌤️  天气穿搭助手 - 安装脚本
echo ================================
echo.

:: 检查 Flutter
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 未检测到 Flutter
    echo.
    echo 请先安装 Flutter:
    echo   1. 访问 https://docs.flutter.dev/get-started/install/windows
    echo   2. 下载 Flutter SDK
    echo   3. 解压到 C:\flutter
    echo   4. 将 C:\flutter\bin 添加到环境变量 Path
    pause
    exit /b 1
)

echo ✅ Flutter 已安装
flutter --version
echo.

:: 获取依赖
echo 📦 正在安装依赖...
flutter pub get

if errorlevel 1 (
    echo ❌ 依赖安装失败
    pause
    exit /b 1
)

echo ✅ 依赖安装完成
echo.

:: 检查设备
echo 📱 可用设备:
flutter devices
echo.

:: 完成
echo 🎉 安装完成！
echo.
echo 运行应用:
echo   flutter run           # 运行到 Android
echo   flutter run -d windows # 运行到 Windows
echo.
echo 更多帮助: cat QUICK_START.md
echo.
pause
