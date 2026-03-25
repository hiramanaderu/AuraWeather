# 构建发布版本指南

## 📱 构建 Android APK

### 1. 环境准备

```bash
# 确保 Flutter 环境正常
flutter doctor

# 进入项目目录
cd /Users/hirama/code/my-todo

# 安装依赖
flutter pub get
```

### 2. 构建 APK

```bash
# 构建发布版 APK
flutter build apk --release

# 输出位置：build/app/outputs/flutter-apk/app-release.apk
```

### 3. 安装到手机

```bash
# 方式一：使用 ADB
adb install build/app/outputs/flutter-apk/app-release.apk

# 方式二：直接复制到手机
# 将 app-release.apk 复制到手机，点击安装

# 方式三：使用 Flutter 安装
flutter install
```

### 4. 生成 App Bundle（Google Play 上架用）

```bash
flutter build appbundle --release
# 输出：build/app/outputs/bundle/release/app-release.aab
```

---

## 🖥️ 构建 Windows EXE

### 1. 环境要求

- Windows 10/11
- Visual Studio 2022（安装「使用 C++ 的桌面开发」）
- Flutter SDK

### 2. 构建 EXE

```bash
# 确保在 Windows 上运行
flutter config --enable-windows-desktop

# 构建
flutter build windows --release

# 输出位置：build/windows/x64/runner/Release/
```

### 3. 打包为独立程序

构建完成后，整个 `Release` 文件夹就是可执行程序：

```
build/windows/x64/runner/Release/
├── weather_assistant.exe    # 主程序
├── flutter_windows.dll      # Flutter 运行库
├── ...                      # 其他依赖文件
└── data/                    # 资源文件
```

**使用方式**：将整个 `Release` 文件夹复制到任意位置，双击 `weather_assistant.exe` 即可运行。

### 4. 制作安装包（可选）

使用 Inno Setup 制作安装程序：

```pascal
; 安装脚本示例
[Setup]
AppName=天气穿搭助手
AppVersion=1.0
DefaultDirName={autopf}\天气穿搭助手
OutputDir=.
OutputBaseFilename=WeatherAssistantSetup

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs

[Icons]
Name: "{group}\天气穿搭助手"; Filename: "{app}\weather_assistant.exe"
Name: "{autodesktop}\天气穿搭助手"; Filename: "{app}\weather_assistant.exe"
```

---

## 🔧 常见问题

### Android 构建失败

```bash
# 问题1：Gradle 下载失败
# 解决：配置国内镜像
# 修改 android/build.gradle

buildscript {
    repositories {
        maven { url 'https://maven.aliyun.com/repository/google' }
        maven { url 'https://maven.aliyun.com/repository/jcenter' }
        maven { url 'https://maven.aliyun.com/nexus/content/groups/public' }
    }
}

allprojects {
    repositories {
        maven { url 'https://maven.aliyun.com/repository/google' }
        maven { url 'https://maven.aliyun.com/repository/jcenter' }
        maven { url 'https://maven.aliyun.com/nexus/content/groups/public' }
    }
}
```

### Windows 构建失败

```bash
# 问题：找不到 Visual Studio
# 解决：指定 VS 路径
flutter config --windows-sdk-path "C:\Program Files\Microsoft Visual Studio\2022\Community"

# 或安装必要的组件
# Visual Studio Installer → 修改 → 使用 C++ 的桌面开发
```

### 签名配置（Android 发布必需）

创建 `android/key.properties`：

```properties
storePassword=你的密码
keyPassword=你的密码
keyAlias=upload
storeFile=你的keystore文件路径
```

生成 keystore：

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

---

## 🚀 快速构建脚本

### macOS/Linux 构建脚本

```bash
#!/bin/bash
# build.sh

echo "🌤️  构建天气穿搭助手"

# 清理
echo "🧹 清理..."
flutter clean

# 获取依赖
echo "📦 获取依赖..."
flutter pub get

# 构建 APK
echo "📱 构建 Android APK..."
flutter build apk --release

# 检查构建结果
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "✅ APK 构建成功！"
    echo "📍 位置: build/app/outputs/flutter-apk/app-release.apk"
    ls -lh build/app/outputs/flutter-apk/app-release.apk
else
    echo "❌ APK 构建失败"
    exit 1
fi

echo "🎉 完成！"
```

### Windows 构建脚本

```powershell
# build.ps1

Write-Host "🌤️  构建天气穿搭助手" -ForegroundColor Cyan

# 清理
Write-Host "🧹 清理..." -ForegroundColor Yellow
flutter clean

# 获取依赖
Write-Host "📦 获取依赖..." -ForegroundColor Yellow
flutter pub get

# 构建 Windows
Write-Host "🖥️  构建 Windows EXE..." -ForegroundColor Yellow
flutter build windows --release

# 检查构建结果
$exePath = "build\windows\x64\runner\Release\weather_assistant.exe"
if (Test-Path $exePath) {
    Write-Host "✅ EXE 构建成功！" -ForegroundColor Green
    Write-Host "📍 位置: $exePath" -ForegroundColor Green
    
    # 打包
    $zipPath = "WeatherAssistant-Windows.zip"
    Compress-Archive -Path "build\windows\x64\runner\Release\*" -DestinationPath $zipPath -Force
    Write-Host "📦 已打包为: $zipPath" -ForegroundColor Green
} else {
    Write-Host "❌ EXE 构建失败" -ForegroundColor Red
}

Write-Host "🎉 完成！" -ForegroundColor Cyan
```

---

## 📦 分发方式

### Android

1. **直接安装**：发送 `app-release.apk` 文件
2. **应用商店**：上传 `.aab` 到 Google Play
3. **内部分发**：使用 Firebase App Distribution

### Windows

1. **压缩包**：将整个 `Release` 文件夹压缩发送
2. **安装程序**：使用 Inno Setup 制作安装包
3. **应用商店**：发布到 Microsoft Store

---

## 🐛 调试构建问题

```bash
# 查看详细日志
flutter build apk --release -v

# 检查 Flutter 环境
flutter doctor -v

# 清理并重新构建
flutter clean
flutter pub get
flutter build apk --release
```
