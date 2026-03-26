# 安装使用指南

## 一、安装 Flutter 环境

### 1.1 Windows 安装

```powershell
# 1. 下载 Flutter SDK
# 访问 https://docs.flutter.dev/get-started/install/windows
# 下载后解压到 C:\flutter

# 2. 配置环境变量
# 右键「此电脑」→ 属性 → 高级系统设置 → 环境变量
# 在 Path 中添加: C:\flutter\bin

# 3. 验证安装
flutter doctor
```

### 1.2 macOS 安装

```bash
# 方式一：使用 Homebrew
brew install flutter

# 方式二：手动安装
cd ~/development
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:`pwd`/flutter/bin"

# 验证安装
flutter doctor
```

### 1.3 安装依赖工具

```bash
# Android 开发（必需）
# 下载 Android Studio: https://developer.android.com/studio
# 安装后打开 Android Studio → SDK Manager → 安装 Android SDK

# Windows 开发（可选）
# 安装 Visual Studio 2022: https://visualstudio.microsoft.com/
# 安装时选择「使用 C++ 的桌面开发」
```

## 二、获取项目

### 方式一：直接下载
```bash
# 项目已在 /Users/hirama/code/my-todo 目录
# 直接复制到你想存放的位置
cp -r /Users/hirama/code/my-todo ~/weather_app
cd ~/weather_app
```

### 方式二：Git 克隆（如果有仓库）
```bash
git clone <仓库地址>
cd weather_app
```

## 三、安装项目依赖

```bash
# 进入项目目录
cd my-todo

# 获取 Flutter 依赖
flutter pub get
```

## 四、运行应用

### 4.1 零配置运行（无需 API Key）

项目已配置为**无需 API Key** 即可使用：

```bash
# 查看已支持的设备
flutter devices

# 运行到 Android 设备/模拟器
flutter run

# 或指定设备
flutter run -d android

# 运行到 Windows
flutter run -d windows
```

### 4.2 首次运行常见问题

```bash
# 问题1：Gradle 下载慢
# 解决：修改 android/build.gradle，使用国内镜像

# 问题2：依赖冲突
flutter clean
flutter pub get
flutter run

# 问题3：Windows 桌面不支持
# 确保已启用 Windows 支持
flutter config --enable-windows-desktop
```

## 五、配置 API Key（可选）

### 5.1 申请 API Key（如需更稳定数据）

```bash
# 1. 高德地图 API
# 访问: https://lbs.amap.com/
# 注册 → 控制台 → 应用管理 → 创建应用 → 添加 Key
# 选择「Web服务」平台

# 2. Kimi AI（如需智能建议）
# 访问: https://platform.moonshot.cn/
# 注册 → API Key 管理 → 创建
```

### 5.2 填入配置

编辑 `lib/config/app_config.dart`：

```dart
// 填入你的 Key（不填也能用基础功能）
static const String amapWeatherKey = '你的高德Key';
static const String kimiApiKey = '你的Kimi Key';
```

## 六、构建发布版本

### 6.1 Android APK

```bash
# 构建发布版 APK
flutter build apk --release

# 输出路径
# build/app/outputs/flutter-apk/app-release.apk

# 安装到手机
adb install build/app/outputs/flutter-apk/app-release.apk
```

### 6.2 Android App Bundle（上架用）

```bash
flutter build appbundle --release
# 输出: build/app/outputs/bundle/release/app-release.aab
```

### 6.3 Windows 桌面版

```bash
flutter build windows --release

# 输出路径
# build/windows/x64/runner/Release/
```

## 七、目录结构说明

```
my-todo/
├── lib/                    # Dart 源代码
│   ├── config/            # 配置文件
│   ├── models/            # 数据模型
│   ├── providers/         # 状态管理
│   ├── screens/           # UI 页面
│   ├── services/          # 网络/数据库服务
│   └── main.dart          # 入口文件
├── android/               # Android 配置
├── windows/               # Windows 配置
├── pubspec.yaml           # 依赖配置
└── README.md              # 项目说明
```

## 八、使用指南

### 8.1 基本操作

1. **查看天气**
   - 打开应用自动显示默认城市天气
   - 首页显示实时天气、7天预报

2. **切换城市**
   - 点击首页顶部城市名
   - 或点击右上角搜索图标
   - 输入城市名搜索

3. **收藏城市**
   - 搜索结果中点击 ❤️ 收藏
   - 在底部导航「收藏」中管理

4. **获取 AI 建议**
   - 首页下滑查看「AI 智能建议」
   - 点击进入详情查看完整建议
   - 可一键复制建议内容

### 8.2 个性化设置

```
设置页面：
├── AI 服务          # 选择 AI 提供商（Kimi/通义千问/DeepSeek）
├── 出行场景         # 通勤/旅行/户外运动/日常散步
├── 穿搭风格         # 通用/男生/女生/运动风/通勤风
├── 温度单位         # 摄氏度/华氏度
└── 数据管理         # 清除缓存
```

## 九、故障排除

### 9.1 无法获取天气数据

```bash
# 1. 检查网络连接
ping www.baidu.com

# 2. 检查是否有网络权限（Android）
# AndroidManifest.xml 中已配置

# 3. 清除缓存重新运行
flutter clean
flutter pub get
flutter run
```

### 9.2 编译错误

```bash
# 1. 更新 Flutter
flutter upgrade

# 2. 检查 Dart 版本
flutter --version

# 3. 重新生成平台文件
flutter create . --platforms=android,windows
```

### 9.3 依赖下载慢

```bash
# 配置国内镜像
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# Windows PowerShell
$env:PUB_HOSTED_URL="https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
```

## 十、更新日志

### v1.0.0
- ✅ 实时天气查询（无需 API Key）
- ✅ 7天天气预报
- ✅ 城市搜索与收藏
- ✅ AI 智能建议（需配置 AI Key）
- ✅ 离线缓存
- ✅ Android + Windows 双平台

## 十一、相关文档

- [无 API 使用指南](./NO_API_SETUP.md)
- [Kimi AI 配置](./KIMI_SETUP.md)
- [Flutter 官方文档](https://docs.flutter.dev/)

## 十二、支持

如有问题，请：
1. 查看 [故障排除](#九故障排除) 章节
2. 检查 Flutter 环境：`flutter doctor`
3. 查看错误日志：`flutter run -v`
