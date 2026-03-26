/// 应用全局配置
class AppConfig {
  // 应用信息
  static const String appName = '天气穿搭助手';
  static const String appVersion = '1.0.0';
  
  // 默认设置
  static const String defaultCity = '上海';
  static const String defaultCityCode = '310000';
  static const String defaultTravelScene = '通勤';
  static const String defaultDressStyle = '通用';
  
  // 天气数据源配置
  // true: 优先使用API，失败时自动使用网页爬取
  // false: 仅使用网页爬取（无需API key）
  static const bool useApiFirst = true;
  
  // 高德天气API配置
  // 如果留空或不配置，将自动使用网页爬取（无需API key）
  static const String amapWeatherKey = '';  // 填入你的高德Key，留空则使用网页爬取
  static const String amapBaseUrl = 'https://restapi.amap.com/v3/weather';
  
  // 和风天气API配置（备用）
  static const String qweatherKey = '';  // 填入你的和风天气Key
  static const String qweatherBaseUrl = 'https://devapi.qweather.com/v7';
  
  // AI API配置
  // 默认使用的AI服务: 'kimi', 'qwen', 'deepseek'
  static const String defaultAIProvider = 'kimi';
  
  // Kimi (Moonshot AI) API - 推荐
  static const String kimiApiKey = 'YOUR_KIMI_API_KEY_HERE';
  static const String kimiBaseUrl = 'https://api.moonshot.cn/v1';
  static const String kimiModel = 'moonshot-v1-8k';  // 可选: moonshot-v1-8k, moonshot-v1-32k, moonshot-v1-128k
  
  // 通义千问 API
  static const String qwenApiKey = 'YOUR_QWEN_API_KEY_HERE';
  static const String qwenBaseUrl = 'https://dashscope.aliyuncs.com/api/v1';
  static const String qwenModel = 'qwen-turbo';
  
  // DeepSeek API
  static const String deepseekApiKey = 'YOUR_DEEPSEEK_API_KEY_HERE';
  static const String deepseekBaseUrl = 'https://api.deepseek.com';
  static const String deepseekModel = 'deepseek-chat';
  
  // 数据存储
  static const int maxHistoryCount = 20;
  static const int cacheValidHours = 2;
  
  // 温度阈值
  static const double coldThreshold = 0.0;    // 寒冷
  static const double coolThreshold = 15.0;   // 凉爽
  static const double warmThreshold = 25.0;   // 温暖
  
  // 出行场景
  static const List<String> travelScenes = [
    '通勤',
    '旅行',
    '户外运动',
    '日常散步',
  ];
  
  // 穿搭风格
  static const List<String> dressStyles = [
    '通用',
    '男生',
    '女生',
    '运动风',
    '通勤风',
  ];
  
  // 天气图标映射
  static const Map<String, String> weatherIcons = {
    '晴': 'sunny',
    '多云': 'cloudy',
    '阴': 'overcast',
    '小雨': 'light_rain',
    '中雨': 'moderate_rain',
    '大雨': 'heavy_rain',
    '暴雨': 'storm',
    '雪': 'snow',
    '雾': 'fog',
    '霾': 'haze',
    '沙尘': 'sand',
  };
}
