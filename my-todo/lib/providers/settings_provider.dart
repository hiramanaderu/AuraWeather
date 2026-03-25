import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';

/// 设置状态管理
class SettingsProvider extends ChangeNotifier {
  // 当前设置
  String _currentCity = AppConfig.defaultCity;
  String _currentCityCode = AppConfig.defaultCityCode;
  String _travelScene = AppConfig.defaultTravelScene;
  String _dressStyle = AppConfig.defaultDressStyle;
  String _aiProvider = AppConfig.aiProvider;
  bool _useCelsius = true;
  bool _darkMode = false;
  
  // Getters
  String get currentCity => _currentCity;
  String get currentCityCode => _currentCityCode;
  String get travelScene => _travelScene;
  String get dressStyle => _dressStyle;
  String get aiProvider => _aiProvider;
  bool get useCelsius => _useCelsius;
  bool get darkMode => _darkMode;
  
  // 温度单位文本
  String get temperatureUnit => _useCelsius ? '°C' : '°F';
  
  // AI提供商显示名称
  String get aiProviderName {
    switch (_aiProvider) {
      case 'kimi':
        return 'Kimi (Moonshot)';
      case 'qwen':
        return '通义千问';
      case 'deepseek':
        return 'DeepSeek';
      default:
        return 'AI';
    }
  }

  SettingsProvider() {
    _loadSettings();
  }

  /// 加载设置
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _currentCity = prefs.getString('current_city') ?? AppConfig.defaultCity;
    _currentCityCode = prefs.getString('current_city_code') ?? AppConfig.defaultCityCode;
    _travelScene = prefs.getString('travel_scene') ?? AppConfig.defaultTravelScene;
    _dressStyle = prefs.getString('dress_style') ?? AppConfig.defaultDressStyle;
    _aiProvider = prefs.getString('ai_provider') ?? AppConfig.aiProvider;
    _useCelsius = prefs.getBool('use_celsius') ?? true;
    _darkMode = prefs.getBool('dark_mode') ?? false;
    notifyListeners();
  }

  /// 保存设置
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_city', _currentCity);
    await prefs.setString('current_city_code', _currentCityCode);
    await prefs.setString('travel_scene', _travelScene);
    await prefs.setString('dress_style', _dressStyle);
    await prefs.setString('ai_provider', _aiProvider);
    await prefs.setBool('use_celsius', _useCelsius);
    await prefs.setBool('dark_mode', _darkMode);
  }

  /// 设置当前城市
  void setCurrentCity(String city, String cityCode) {
    _currentCity = city;
    _currentCityCode = cityCode;
    _saveSettings();
    notifyListeners();
  }

  /// 设置出行场景
  void setTravelScene(String scene) {
    _travelScene = scene;
    _saveSettings();
    notifyListeners();
  }

  /// 设置穿搭风格
  void setDressStyle(String style) {
    _dressStyle = style;
    _saveSettings();
    notifyListeners();
  }

  /// 切换温度单位
  void toggleTemperatureUnit() {
    _useCelsius = !_useCelsius;
    _saveSettings();
    notifyListeners();
  }

  /// 切换暗黑模式
  void toggleDarkMode() {
    _darkMode = !_darkMode;
    _saveSettings();
    notifyListeners();
  }
  
  /// 设置AI提供商
  void setAIProvider(String provider) {
    _aiProvider = provider;
    _saveSettings();
    notifyListeners();
  }

  /// 温度转换
  double convertTemperature(double celsius) {
    if (_useCelsius) return celsius;
    return (celsius * 9 / 5) + 32;
  }

  /// 格式化温度显示
  String formatTemperature(double temperature) {
    final converted = convertTemperature(temperature);
    return '${converted.round()}$temperatureUnit';
  }
}
