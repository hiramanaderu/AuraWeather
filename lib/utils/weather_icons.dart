import 'package:flutter/material.dart';

/// 天气图标映射工具
class WeatherIcons {
  // 天气图标数据
  static const Map<String, IconData> _iconMap = {
    // 晴天
    '晴': Icons.wb_sunny,
    'sunny': Icons.wb_sunny,
    'clear': Icons.wb_sunny,
    
    // 多云
    '多云': Icons.wb_cloudy,
    'cloudy': Icons.wb_cloudy,
    'partly_cloudy': Icons.wb_cloudy,
    
    // 阴天
    '阴': Icons.cloud,
    'overcast': Icons.cloud,
    
    // 雨天
    '小雨': Icons.water_drop,
    'light_rain': Icons.water_drop,
    '中雨': Icons.umbrella,
    'moderate_rain': Icons.umbrella,
    '大雨': Icons.thunderstorm,
    'heavy_rain': Icons.thunderstorm,
    '暴雨': Icons.storm,
    'storm': Icons.storm,
    '阵雨': Icons.water_drop,
    'shower': Icons.water_drop,
    
    // 雪天
    '雪': Icons.ac_unit,
    'snow': Icons.ac_unit,
    '小雪': Icons.ac_unit,
    'light_snow': Icons.ac_unit,
    '中雪': Icons.ac_unit,
    'moderate_snow': Icons.ac_unit,
    '大雪': Icons.ac_unit,
    'heavy_snow': Icons.ac_unit,
    '暴雪': Icons.ac_unit,
    'blizzard': Icons.ac_unit,
    '雨夹雪': Icons.grain,
    'sleet': Icons.grain,
    
    // 雾和霾
    '雾': Icons.foggy,
    'fog': Icons.foggy,
    '霾': Icons.cloud_queue,
    'haze': Icons.cloud_queue,
    '沙尘': Icons.wind_power,
    'sand': Icons.wind_power,
    '浮尘': Icons.wind_power,
    'dust': Icons.wind_power,
    
    // 风
    '风': Icons.air,
    'wind': Icons.air,
    '大风': Icons.wind_power,
    'strong_wind': Icons.wind_power,
    '飓风': Icons.cyclone,
    'hurricane': Icons.cyclone,
    
    // 雷电
    '雷': Icons.thunderstorm,
    'thunder': Icons.thunderstorm,
    '雷阵雨': Icons.thunderstorm,
    'thunder_shower': Icons.thunderstorm,
    
    // 冰雹
    '冰雹': Icons.hail,
    'hail': Icons.hail,
  };

  /// 获取天气图标
  static IconData getIcon(String weather) {
    return _iconMap[weather] ?? Icons.wb_cloudy;
  }

  /// 获取天气图标（带备用）
  static IconData getIconWithFallback(String? weather) {
    if (weather == null || weather.isEmpty) {
      return Icons.wb_cloudy;
    }
    return _iconMap[weather] ?? Icons.wb_cloudy;
  }

  /// 获取天气颜色
  static Color getColor(String weather) {
    if (weather.contains('晴')) return const Color(0xFFFFA726);
    if (weather.contains('多云')) return const Color(0xFF66BB6A);
    if (weather.contains('阴')) return const Color(0xFF78909C);
    if (weather.contains('雨')) return const Color(0xFF42A5F5);
    if (weather.contains('雪')) return const Color(0xFF90CAF9);
    if (weather.contains('雾') || weather.contains('霾')) return const Color(0xFFB0BEC5);
    if (weather.contains('风')) return const Color(0xFF81C784);
    if (weather.contains('雷')) return const Color(0xFFEF5350);
    return const Color(0xFF78909C);
  }

  /// 获取天气背景渐变
  static List<Color> getGradient(String weather) {
    if (weather.contains('晴')) {
      return [const Color(0xFFFFE0B2), const Color(0xFFFFF3E0)];
    }
    if (weather.contains('多云')) {
      return [const Color(0xFFC8E6C9), const Color(0xFFE8F5E9)];
    }
    if (weather.contains('阴')) {
      return [const Color(0xFFECEFF1), const Color(0xFFF5F5F5)];
    }
    if (weather.contains('雨')) {
      return [const Color(0xFFBBDEFB), const Color(0xFFE3F2FD)];
    }
    if (weather.contains('雪')) {
      return [const Color(0xFFE3F2FD), const Color(0xFFF5F5F5)];
    }
    if (weather.contains('雾') || weather.contains('霾')) {
      return [const Color(0xFFF5F5F5), const Color(0xFFFAFAFA)];
    }
    return [const Color(0xFFF5F5F5), const Color(0xFFFFFFFF)];
  }
}

/// 天气描述工具
class WeatherDescriptions {
  /// 获取温度描述
  static String getTempDescription(double temp) {
    if (temp < -10) return '极寒';
    if (temp < 0) return '寒冷';
    if (temp < 10) return '冷';
    if (temp < 18) return '凉爽';
    if (temp < 25) return '舒适';
    if (temp < 30) return '温暖';
    if (temp < 35) return '炎热';
    return '酷热';
  }

  /// 获取风力描述
  static String getWindDescription(String windPower) {
    if (windPower.isEmpty) return '微风';
    
    try {
      final level = int.parse(windPower.replaceAll(RegExp(r'[^0-9]'), ''));
      if (level <= 2) return '微风';
      if (level <= 4) return '和风';
      if (level <= 6) return '强风';
      if (level <= 8) return '大风';
      return '狂风';
    } catch (e) {
      return windPower;
    }
  }

  /// 获取湿度描述
  static String getHumidityDescription(String humidity) {
    try {
      final value = int.parse(humidity);
      if (value < 30) return '干燥';
      if (value < 60) return '舒适';
      if (value < 80) return '潮湿';
      return '高湿';
    } catch (e) {
      return '适中';
    }
  }

  /// 获取空气质量描述
  static String getAqiDescription(int aqi) {
    if (aqi <= 50) return '优';
    if (aqi <= 100) return '良';
    if (aqi <= 150) return '轻度污染';
    if (aqi <= 200) return '中度污染';
    if (aqi <= 300) return '重度污染';
    return '严重污染';
  }

  /// 获取空气质量颜色
  static Color getAqiColor(int aqi) {
    if (aqi <= 50) return const Color(0xFF4CAF50);
    if (aqi <= 100) return const Color(0xFFFFEB3B);
    if (aqi <= 150) return const Color(0xFFFF9800);
    if (aqi <= 200) return const Color(0xFFF44336);
    if (aqi <= 300) return const Color(0xFF9C27B0);
    return const Color(0xFF795548);
  }

  /// 获取紫外线描述
  static String getUvDescription(String uv) {
    try {
      final value = int.parse(uv);
      if (value <= 2) return '弱';
      if (value <= 5) return '中等';
      if (value <= 7) return '强';
      if (value <= 10) return '很强';
      return '极强';
    } catch (e) {
      return '中等';
    }
  }
}
