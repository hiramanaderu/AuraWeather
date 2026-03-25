# 🌤️ 天气穿搭助手

一款基于 Flutter 开发的 AI 天气预测+出行穿搭助手应用，**无需 API Key 即可使用**，支持 Android 和 Windows 双平台。

---

## ✨ 核心特性

- 🌡️ **实时天气** - 全国城市实时天气查询
- 📅 **7天预报** - 未来一周天气预报
- 🤖 **AI 建议** - 智能出行+穿搭建议（可选）
- 💾 **离线可用** - 本地缓存，无网也能看
- 🎨 **极简设计** - 纯白卡片式界面
- 🔌 **零配置** - 无需申请 API Key

---

## 🚀 快速开始（5分钟）

### 1. 安装 Flutter

```bash
# macOS/Linux
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:`pwd`/flutter/bin"

# Windows
# 下载: https://docs.flutter.dev/get-started/install/windows
# 解压到 C:\flutter，添加到 Path
```

### 2. 运行应用

```bash
cd my-todo

# 一键安装（推荐）
./install.sh          # macOS/Linux
install.bat           # Windows

# 或手动运行
flutter pub get       # 安装依赖
flutter run           # 运行到 Android
flutter run -d windows # 运行到 Windows
```

### 3. 开始使用

- **查看天气** - 打开即显示默认城市
- **切换城市** - 点击顶部城市名或搜索
- **获取建议** - 首页下滑查看 AI 建议

---

## 📁 项目结构

```
lib/
├── config/           # 配置（API Key 等）
├── models/           # 数据模型
├── providers/        # 状态管理
├── screens/          # UI 页面
├── services/         # 网络/数据库服务
│   ├── api_service.dart           # 官方 API
│   ├── web_scraper_service.dart   # 网页爬取（无需 Key）
│   └── database_service.dart      # 本地缓存
└── main.dart         # 入口
```

---

## ⚙️ 配置说明

### 方式一：零配置（推荐）

**无需任何操作**，直接运行即可！

应用自动使用网页爬取获取数据：
- 百度天气接口（公开）
- 天气网数据

### 方式二：使用 API（更稳定）

编辑 `lib/config/app_config.dart`：

```dart
// 高德天气 API Key
static const String amapWeatherKey = '你的Key';

// AI 服务（Kimi/通义千问/DeepSeek）
static const String kimiApiKey = '你的Key';
```

---

## 📱 功能截图

| 首页天气 | 7天预报 | AI 建议 |
|---------|--------|--------|
| 实时温度+天气 | 横向滑动卡片 | 出行+穿搭建议 |
| 湿度/风力/气压 | 最高/最低温度 | 风险预警 |
| 生活指数 | 天气图标 | 一键复制 |

---

## 📦 构建发布

```bash
# Android APK
flutter build apk --release

# Android App Bundle（上架）
flutter build appbundle --release

# Windows 桌面版
flutter build windows --release
```

---

## 📚 文档

| 文档 | 说明 |
|------|------|
| [QUICK_START.md](./QUICK_START.md) | 5分钟快速开始 |
| [INSTALL.md](./INSTALL.md) | 详细安装指南 |
| [NO_API_SETUP.md](./NO_API_SETUP.md) | 零配置使用说明 |
| [KIMI_SETUP.md](./KIMI_SETUP.md) | AI 服务配置 |

---

## 🔧 技术栈

- **Flutter** 3.x - 跨端框架
- **Provider** - 状态管理
- **Dio** - 网络请求
- **SQLite** - 本地存储
- **html** - 网页解析

---

## ✅ 功能清单

- [x] 实时天气（网页爬取，无需 Key）
- [x] 7天天气预报
- [x] 城市搜索与收藏
- [x] 历史记录
- [x] 离线缓存
- [x] AI 天气总结
- [x] AI 出行建议
- [x] AI 穿搭建议
- [x] 温度单位切换
- [x] 多 AI 服务切换（Kimi/通义千问/DeepSeek）
- [x] Android + Windows 双平台

---

## 🐛 常见问题

**Q: 需要申请 API Key 吗？**  
A: 不需要！基础天气功能通过网页爬取获取，无需任何 Key。

**Q: 为什么需要 AI Key？**  
A: AI 建议功能需要调用大模型 API，这是可选功能。

**Q: 数据准确吗？**  
A: 网页数据来自百度天气、天气网等，与官方 App 基本一致。

**Q: 支持哪些城市？**  
A: 支持全国所有城市，以及部分国外城市。

---

## 📄 许可证

MIT License

---

**🎉 现在就可以开始使用了！**
