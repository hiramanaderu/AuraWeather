# Kimi (Moonshot AI) 接入指南

## 简介

本应用已集成 **Kimi (Moonshot AI)** 作为主要的AI建议服务提供商。Kimi是由月之暗面（Moonshot AI）开发的大语言模型，具有优秀的理解和生成能力。

## 快速配置

### 1. 获取API Key

1. 访问 [Kimi开放平台](https://platform.moonshot.cn/)
2. 注册账号并登录
3. 进入「API Key管理」页面
4. 点击「创建API Key」
5. 复制生成的API Key

### 2. 配置应用

编辑 `lib/config/app_config.dart` 文件：

```dart
// Kimi (Moonshot AI) API - 推荐
static const String kimiApiKey = '你的API密钥';
static const String kimiBaseUrl = 'https://api.moonshot.cn/v1';
static const String kimiModel = 'moonshot-v1-8k';  // 可选模型见下方
```

### 3. 选择Kimi作为AI服务

编辑 `lib/config/app_config.dart`：

```dart
// 默认使用的AI服务
static const String defaultAIProvider = 'kimi';
```

或者在应用内的「设置」→「AI服务」中选择「Kimi」。

## 可选模型

| 模型 | 上下文长度 | 适用场景 |
|------|-----------|---------|
| `moonshot-v1-8k` | 8K | 简短对话，快速响应 |
| `moonshot-v1-32k` | 32K | 标准对话，天气建议推荐 |
| `moonshot-v1-128k` | 128K | 长文本，复杂分析 |

建议：**moonshot-v1-8k** 已足够满足天气建议需求，响应速度最快。

## 费用说明

- Kimi API采用按量计费模式
- 新用户有免费试用额度
- 具体价格请参考 [Kimi官方定价](https://platform.moonshot.cn/docs/pricing)

## 备用AI服务

如果Kimi服务暂时不可用，应用会自动回退到其他配置的AI服务：

1. **通义千问**（阿里云）
   - 访问 [阿里云百炼](https://bailian.console.aliyun.com/)
   - 配置 `qwenApiKey`

2. **DeepSeek**
   - 访问 [DeepSeek平台](https://platform.deepseek.com/)
   - 配置 `deepseekApiKey`

## 故障排除

### API调用失败

1. 检查API Key是否正确
2. 检查网络连接
3. 查看API Key是否有足够余额
4. 检查是否超出速率限制

### 响应缓慢

1. 尝试切换到 `moonshot-v1-8k` 模型
2. 检查网络状况
3. 考虑启用缓存功能

## 技术支持

- Kimi官方文档：https://platform.moonshot.cn/docs
- Kimi API参考：https://platform.moonshot.cn/docs/api-reference
