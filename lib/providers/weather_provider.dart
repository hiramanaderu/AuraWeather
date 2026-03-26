import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../services/api_service.dart';
import '../services/web_scraper_service.dart';
import '../services/database_service.dart';
import '../config/app_config.dart';

/// 天气状态管理
class WeatherProvider extends ChangeNotifier {
  final WeatherApiService _weatherApi = WeatherApiService.instance;
  final WebScraperService _scraperService = WebScraperService.instance;
  final WeatherServiceWithFallback _fallbackService = WeatherServiceWithFallback.instance;
  final DatabaseService _db = DatabaseService.instance;

  // 状态
  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _error;
  DateTime? _lastUpdateTime;

  // Getters
  WeatherData? get weatherData => _weatherData;
  CurrentWeather? get currentWeather => _weatherData?.current;
  List<DailyForecast> get forecast => _weatherData?.forecast ?? [];
  LifeIndex? get lifeIndex => _weatherData?.lifeIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastUpdateTime => _lastUpdateTime;
  bool get hasData => _weatherData != null;

  /// 获取天气（优先缓存）
  Future<void> fetchWeather(String cityCode, {bool forceRefresh = false}) async {
    if (!forceRefresh) {
      // 尝试从缓存获取
      final cached = await _db.getCachedWeather(cityCode);
      if (cached != null) {
        _weatherData = cached;
        _lastUpdateTime = DateTime.now();
        notifyListeners();
        return;
      }
    }

    await _fetchFromNetwork(cityCode);
  }

  /// 从网络获取天气（支持API和网页爬取回退）
  Future<void> _fetchFromNetwork(String cityCode) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 首先尝试使用fallback服务（优先API，失败自动回退到网页爬取）
      final response = await _fallbackService.getWeather(cityCode, cityCode);

      if (response.success && response.data != null) {
        _weatherData = response.data;
        _lastUpdateTime = DateTime.now();

        // 缓存数据
        await _db.cacheWeather(cityCode, _weatherData!);
        
        // 清理过期缓存
        await _db.clearExpiredCache();
      } else {
        _error = response.message ?? '获取天气失败';
      }
    } catch (e) {
      _error = '网络异常，请检查网络连接';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 通过城市名获取天气（用于没有API key的情况）
  Future<void> fetchWeatherByName(String cityName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 使用百度天气接口（无需API key）
      final response = await _scraperService.getWeatherFromBaidu(cityName);

      if (response.success && response.data != null) {
        _weatherData = response.data;
        _lastUpdateTime = DateTime.now();

        // 缓存数据
        await _db.cacheWeather(cityName, _weatherData!);
      } else {
        // 百度失败，尝试天气网
        final webResponse = await _scraperService.getWeatherByCityName(cityName);
        
        if (webResponse.success && webResponse.data != null) {
          _weatherData = webResponse.data;
          _lastUpdateTime = DateTime.now();
          await _db.cacheWeather(cityName, _weatherData!);
        } else {
          _error = webResponse.message ?? '获取天气失败';
        }
      }
    } catch (e) {
      _error = '网络异常，请检查网络连接';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 刷新天气
  Future<void> refreshWeather(String cityCode) async {
    await _fetchFromNetwork(cityCode);
  }

  /// 获取指定日期的预报
  DailyForecast? getForecastForDay(int dayIndex) {
    if (_weatherData == null || dayIndex >= _weatherData!.forecast.length) {
      return null;
    }
    return _weatherData!.forecast[dayIndex];
  }

  /// 获取温度趋势数据（用于图表）
  List<double> getTemperatureTrend() {
    if (_weatherData == null) return [];
    
    return _weatherData!.forecast.map((f) => f.dayTemp).toList();
  }

  /// 获取温度范围描述
  String getTemperatureRange() {
    if (_weatherData == null) return '';
    
    final temps = _weatherData!.forecast.expand((f) => [f.dayTemp, f.nightTemp]).toList();
    final minTemp = temps.reduce((a, b) => a < b ? a : b);
    final maxTemp = temps.reduce((a, b) => a > b ? a : b);
    
    return '${minTemp.round()}° - ${maxTemp.round()}°';
  }

  /// 获取当前温度区间
  String getTemperatureZone() {
    final temp = _weatherData?.current.temperature ?? 0;
    
    if (temp < AppConfig.coldThreshold) return '严寒';
    if (temp < AppConfig.coolThreshold) return '凉爽';
    if (temp < AppConfig.warmThreshold) return '舒适';
    return '炎热';
  }

  /// 是否需要带伞
  bool get needUmbrella {
    final weather = _weatherData?.current.weather ?? '';
    return weather.contains('雨') || weather.contains('雪');
  }

  /// 是否需要防晒
  bool get needSunscreen {
    final weather = _weatherData?.current.weather ?? '';
    return weather.contains('晴') && (_weatherData?.current.temperature ?? 0) > 25;
  }

  /// 是否需要保暖
  bool get needWarmClothes {
    return (_weatherData?.current.temperature ?? 0) < 10;
  }

  /// 是否有大风
  bool get hasStrongWind {
    final windPower = _weatherData?.current.windPower ?? '';
    if (windPower.isEmpty) return false;
    
    // 解析风力等级
    try {
      final level = int.parse(windPower.replaceAll(RegExp(r'[^0-9]'), ''));
      return level >= 6;
    } catch (e) {
      return false;
    }
  }

  /// 清除错误
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
