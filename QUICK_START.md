# 快速开始（5分钟运行）

## 第一步：安装 Flutter（如果还没有）

### Windows
```powershell
# 下载 Flutter
# https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.0-stable.zip

# 解压到 C:\flutter
# 添加到环境变量 Path: C:\flutter\bin

# 验证
flutter doctor
```

### Mac
```bash
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
```

## 第二步：运行应用

```bash
# 进入项目目录
cd /Users/hirama/code/my-todo

# 安装依赖
flutter pub get

# 查看可用设备
flutter devices

# 运行（选其一）
flutter run                    # Android
flutter run -d windows         # Windows
```

## 第三步：开始使用

1. **首页** - 自动显示天气
2. **搜索** - 点击右上角 🔍 切换城市
3. **收藏** - 点击 ❤️ 收藏常用城市
4. **设置** - 切换场景、风格、AI服务

## 常见问题

### Q: 提示 "No connected devices"？
```bash
# Android 模拟器
# 打开 Android Studio → Device Manager → Create Device

# 或连接真机
# 开启开发者模式 → USB调试 → 连接电脑
```

### Q: 运行很慢？
```bash
# 首次编译较慢，后续会快
# 使用 release 模式运行更快
flutter run --release
```

### Q: 需要 API Key 吗？
```
不需要！基础天气功能无需任何 Key。
如需 AI 建议，才需要配置 Kimi/通义千问 Key。
```

## 下一步

- 完整安装指南：[INSTALL.md](./INSTALL.md)
- 配置 AI：[KIMI_SETUP.md](./KIMI_SETUP.md)
- 无 Key 使用：[NO_API_SETUP.md](./NO_API_SETUP.md)

**现在就可以使用天气应用了！** 🌤️
