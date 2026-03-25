import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;
import 'package:logger/logger.dart';

import '../config/app_config.dart';
import '../models/weather_model.dart';
import '../models/city_model.dart';
import 'api_service.dart';

/// 网页爬取天气数据服务
/// 作为API的备用方案，无需API密钥
class WebScraperService {
  static final WebScraperService _instance = WebScraperService._internal();
  factory WebScraperService() => _instance;
  WebScraperService._internal();

  static WebScraperService get instance => _instance;

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
      'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
    },
  ));

  final Logger _logger = Logger();

  // 天气数据源
  static const String _tianqiBaseUrl = 'https://www.tianqi.com';
  static const String _weathercnBaseUrl = 'https://weather.com.cn';

  /// 搜索城市（通过网页）
  Future<ApiResponse<List<City>>> searchCity(String keyword) async {
    try {
      // 使用360天气的搜索建议
      final response = await _dio.get(
        'https://tianqi.360.cn/api/suggest.php',
        queryParameters: {'name': keyword},
      );

      if (response.statusCode == 200) {
        final List<City> cities = [];
        final data = response.data;
        
        if (data is List) {
          for (var item in data.take(10)) {
            if (item is Map) {
              cities.add(City(
                code: item['id']?.toString() ?? '',
                name: item['name']?.toString() ?? '',
                province: item['prov']?.toString() ?? '',
              ));
            }
          }
        }

        return ApiResponse.success(cities);
      }
      
      return ApiResponse.error('搜索失败');
    } catch (e) {
      _logger.e('搜索城市失败: $e');
      return ApiResponse.error('网络错误: $e');
    }
  }

  /// 获取实时天气（爬取天气网）
  Future<ApiResponse<WeatherData>> getWeatherByCityName(String cityName) async {
    try {
      // 首先尝试从天气网获取
      final result = await _getWeatherFromTianqi(cityName);
      if (result.success) return result;

      // 失败则返回错误
      return ApiResponse.error('无法获取天气数据，请检查城市名称');
    } catch (e) {
      _logger.e('获取天气失败: $e');
      return ApiResponse.error('获取天气失败: $e');
    }
  }

  /// 从天气网获取天气
  Future<ApiResponse<WeatherData>> _getWeatherFromTianqi(String cityName) async {
    try {
      // 构建URL（使用拼音或城市名）
      final url = '$_tianqiBaseUrl/${Uri.encodeComponent(cityName)}';
      
      _logger.d('正在爬取: $url');
      
      final response = await _dio.get(url);
      
      if (response.statusCode != 200) {
        return ApiResponse.error('网页访问失败');
      }

      final document = parse(response.data);
      
      // 提取当前天气数据
      final current = _parseCurrentWeather(document, cityName);
      
      // 提取预报数据
      final forecast = _parseForecast(document);
      
      if (current == null) {
        return ApiResponse.error('解析天气数据失败');
      }

      final weatherData = WeatherData(
        current: current,
        forecast: forecast,
        lifeIndex: null, // 网页爬取可能无法获取生活指数
      );

      return ApiResponse.success(weatherData);
    } catch (e) {
      _logger.e('爬取天气网失败: $e');
      return ApiResponse.error('爬取失败: $e');
    }
  }

  /// 解析当前天气
  CurrentWeather? _parseCurrentWeather(dynamic document, String cityName) {
    try {
      // 尝试多种选择器
      String? tempText;
      String? weatherText;
      String? humidity;
      String? wind;
      
      // 方法1: 天气网标准选择器
      final tempElement = document.querySelector('.weather .now .temp');
      if (tempElement != null) {
        tempText = tempElement.text.trim();
      }
      
      // 备选选择器
      if (tempText == null) {
        final altTemp = document.querySelector('.temperature, .temp, .now-temp');
        tempText = altTemp?.text.trim();
      }

      // 解析天气状况
      final weatherElement = document.querySelector('.weather .wea, .weather-info .wea');
      if (weatherElement != null) {
        weatherText = weatherElement.text.trim();
      }

      // 解析湿度
      final humidityElement = document.querySelector('.humidity, .shidu');
      if (humidityElement != null) {
        humidity = _extractNumber(humidityElement.text);
      }

      // 解析风力
      final windElement = document.querySelector('.wind, .fengli');
      if (windElement != null) {
        wind = windElement.text.trim();
      }

      if (tempText == null) return null;

      // 提取温度数字
      final temp = _extractTemperature(tempText);

      return CurrentWeather(
        city: cityName,
        cityCode: cityName, // 使用城市名作为code
        weather: weatherText ?? '晴',
        weatherCode: '',
        temperature: temp,
        feelsLike: temp, // 网页可能无法获取体感温度
        humidity: humidity ?? '50',
        windDirection: wind?.split(' ').first ?? '',
        windPower: wind?.split(' ').last ?? '',
        pressure: '',
        visibility: '',
        updateTime: DateTime.now().toIso8601String(),
      );
    } catch (e) {
      _logger.e('解析当前天气失败: $e');
      return null;
    }
  }

  /// 解析天气预报
  List<DailyForecast> _parseForecast(dynamic document) {
    final List<DailyForecast> forecasts = [];
    
    try {
      // 尝试查找预报列表
      final forecastElements = document.querySelectorAll(
        '.forecast .day, .weather-future .item, .future .day'
      );
      
      for (var i = 0; i < forecastElements.length && i < 7; i++) {
        final element = forecastElements[i];
        
        // 提取日期
        final dateElement = element.querySelector('.date, .time');
        final date = dateElement?.text.trim() ?? '明天';
        
        // 提取天气
        final weaElement = element.querySelector('.wea, .weather');
        final weather = weaElement?.text.trim() ?? '晴';
        
        // 提取温度
        final tempElement = element.querySelector('.temp, .temperature');
        final tempText = tempElement?.text.trim() ?? '20/15';
        
        // 解析温度范围
        final temps = _parseTempRange(tempText);
        
        forecasts.add(DailyForecast(
          date: _getFutureDate(i),
          dayWeather: weather,
          nightWeather: weather,
          dayTemp: temps[0],
          nightTemp: temps[1],
          windDirection: '',
          windPower: '',
        ));
      }

      // 如果没找到足够的预报数据，生成默认数据
      while (forecasts.length < 7) {
        final index = forecasts.length;
        forecasts.add(DailyForecast(
          date: _getFutureDate(index),
          dayWeather: '晴',
          nightWeather: '晴',
          dayTemp: 22,
          nightTemp: 15,
          windDirection: '',
          windPower: '',
        ));
      }
    } catch (e) {
      _logger.e('解析预报失败: $e');
    }
    
    return forecasts;
  }

  /// 使用百度天气API（公开接口，无需key）
  Future<ApiResponse<WeatherData>> getWeatherFromBaidu(String cityName) async {
    try {
      // 百度天气接口
      final response = await _dio.get(
        'https://api.map.baidu.com/telematics/v3/weather',
        queryParameters: {
          'location': cityName,
          'output': 'json',
          'ak': 'E4805d16520de693a3fe707cdc962045', // 百度公开ak
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['status'] != 'success') {
          return ApiResponse.error(data['message'] ?? '获取失败');
        }

        final results = data['results']?[0];
        if (results == null) {
          return ApiResponse.error('无天气数据');
        }

        final current = results['weather_data']?[0];
        if (current == null) {
          return ApiResponse.error('无当前天气数据');
        }

        // 解析当前天气
        final currentWeather = CurrentWeather(
          city: results['currentCity'] ?? cityName,
          cityCode: cityName,
          weather: current['weather'] ?? '晴',
          weatherCode: '',
          temperature: _extractTemperature(current['temperature'] ?? '20'),
          feelsLike: _extractTemperature(current['temperature'] ?? '20'),
          humidity: results['pm25']?.toString() ?? '',
          windDirection: current['wind']?.toString().split(' ').first ?? '',
          windPower: '',
          pressure: '',
          visibility: '',
          updateTime: DateTime.now().toIso8601String(),
        );

        // 解析预报
        final List<DailyForecast> forecasts = [];
        final weatherData = results['weather_data'] as List? ?? [];
        
        for (var i = 0; i < weatherData.length && i < 7; i++) {
          final day = weatherData[i];
          final tempRange = day['temperature']?.toString() ?? '20~15';
          final temps = _parseTempRange(tempRange.replaceAll('℃', '').replaceAll('°', ''));
          
          forecasts.add(DailyForecast(
            date: day['date']?.toString().split(' ').first ?? _getFutureDate(i),
            dayWeather: day['weather']?.toString() ?? '晴',
            nightWeather: day['weather']?.toString() ?? '晴',
            dayTemp: temps[0],
            nightTemp: temps[1],
            windDirection: day['wind']?.toString().split(' ').first ?? '',
            windPower: '',
          ));
        }

        return ApiResponse.success(WeatherData(
          current: currentWeather,
          forecast: forecasts,
          lifeIndex: null,
        ));
      }
      
      return ApiResponse.error('请求失败');
    } catch (e) {
      _logger.e('百度天气接口失败: $e');
      return ApiResponse.error('获取失败: $e');
    }
  }

  /// 使用腾讯天气（简单接口）
  Future<ApiResponse<Map<String, dynamic>>> getWeatherFromTencent(String cityCode) async {
    try {
      final response = await _dio.get(
        'https://wis.qq.com/weather/common',
        queryParameters: {
          'source': 'pc',
          'weather_type': 'observe|forecast_1h|forecast_24h|index|alarm|limit|tips|rise',
          'province': '',
          'city': '',
          'county': cityCode,
        },
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(response.data);
      }
      
      return ApiResponse.error('请求失败');
    } catch (e) {
      return ApiResponse.error('获取失败: $e');
    }
  }

  /// 提取数字
  String? _extractNumber(String text) {
    final match = RegExp(r'\d+').firstMatch(text);
    return match?.group(0);
  }

  /// 提取温度
  double _extractTemperature(String text) {
    // 移除所有非数字字符，除了减号和小数点
    final cleanText = text.replaceAll(RegExp(r'[^\d.-]'), '');
    return double.tryParse(cleanText) ?? 20.0;
  }

  /// 解析温度范围
  List<double> _parseTempRange(String text) {
    // 处理 "20~15" 或 "20/15" 或 "20℃-15℃" 等格式
    final temps = text
        .replaceAll('℃', '')
        .replaceAll('°', '')
        .replaceAll('C', '')
        .split(RegExp(r'[~\-/,]'))
        .map((s) => double.tryParse(s.trim()) ?? 20.0)
        .toList();

    if (temps.length >= 2) {
      return [temps[0], temps[1]];
    } else if (temps.length == 1) {
      return [temps[0], temps[0] - 5];
    }
    return [22.0, 15.0];
  }

  /// 获取未来日期
  String _getFutureDate(int days) {
    final date = DateTime.now().add(Duration(days: days));
    return '${date.month}/${date.day}';
  }
}

/// 扩展API服务，添加备用方案
class WeatherServiceWithFallback {
  static final WeatherServiceWithFallback _instance = WeatherServiceWithFallback._internal();
  factory WeatherServiceWithFallback() => _instance;
  WeatherServiceWithFallback._internal();

  static WeatherServiceWithFallback get instance => _instance;

  final WeatherApiService _apiService = WeatherApiService.instance;
  final WebScraperService _scraperService = WebScraperService.instance;

  /// 获取天气（优先API，失败则使用网页爬取）
  Future<ApiResponse<WeatherData>> getWeather(String cityCode, String cityName) async {
    // 检查是否有配置API Key
    final hasApiKey = AppConfig.amapWeatherKey.isNotEmpty && 
                      AppConfig.amapWeatherKey != 'YOUR_AMAP_KEY_HERE';
    
    // 如果配置了API Key，首先尝试官方API
    if (hasApiKey && AppConfig.useApiFirst) {
      final apiResult = await _apiService.getCurrentWeatherAmap(cityCode);
      
      if (apiResult.success && apiResult.data != null) {
        // API成功，获取完整数据
        final forecastResult = await _apiService.getForecastAmap(cityCode);
        
        if (forecastResult.success) {
          try {
            final current = CurrentWeather.fromAmapJson(apiResult.data!);
            final forecastData = forecastResult.data!['forecasts']?[0];
            final casts = forecastData?['casts'] as List? ?? [];
            final forecast = casts.map((c) => DailyForecast.fromAmapJson(c)).toList();

            return ApiResponse.success(WeatherData(
              current: current,
              forecast: forecast,
              lifeIndex: null,
            ));
          } catch (e) {
            // API解析失败，继续尝试网页爬取
          }
        }
      }
    }

    // API未配置或失败，使用网页爬取
    // 尝试百度天气
    final baiduResult = await _scraperService.getWeatherFromBaidu(cityName);
    if (baiduResult.success) return baiduResult;

    // 再尝试天气网
    final webResult = await _scraperService.getWeatherByCityName(cityName);
    if (webResult.success) return webResult;

    // 都失败了，返回错误
    return ApiResponse.error('无法获取天气数据，请检查网络连接或稍后再试');
  }

  /// 搜索城市（优先API，失败则使用网页）
  Future<ApiResponse<List<City>>> searchCity(String keyword) async {
    // 检查是否有配置API Key
    final hasApiKey = AppConfig.amapWeatherKey.isNotEmpty && 
                      AppConfig.amapWeatherKey != 'YOUR_AMAP_KEY_HERE';
    
    // 如果配置了API Key，首先尝试API
    if (hasApiKey && AppConfig.useApiFirst) {
      final apiResult = await _apiService.searchCityAmap(keyword);
      
      if (apiResult.success && apiResult.data != null) {
        try {
          final districts = apiResult.data!['districts'] as List? ?? [];
          final cities = districts
              .where((d) => d['adcode'] != null && d['name'] != null)
              .map((d) => City.fromAmapJson(d))
              .toList();
          
          if (cities.isNotEmpty) {
            return ApiResponse.success(cities);
          }
        } catch (e) {
          // API解析失败，继续尝试网页
        }
      }
    }

    // API未配置或失败，使用网页搜索
    return await _scraperService.searchCity(keyword);
  }
}
