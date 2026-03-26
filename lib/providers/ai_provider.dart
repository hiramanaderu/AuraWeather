import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/app_config.dart';
import '../models/weather_model.dart';
import '../models/ai_suggestion_model.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';

/// AI建议状态管理
class AIProvider extends ChangeNotifier {
  final AIService _aiService = AIService.instance;
  final DatabaseService _db = DatabaseService.instance;

  // 状态
  AISuggestion? _currentSuggestion;
  bool _isLoading = false;
  String? _error;
  int _retryCount = 0;
  static const int maxRetries = 3;
  
  // 可用的AI提供商列表
  final List<String> _providers = ['kimi', 'qwen', 'deepseek'];
  
  // 获取AI提供商名称（用于显示）
  String getProviderName(String provider) {
    switch (provider) {
      case 'kimi':
        return 'Kimi';
      case 'qwen':
        return '通义千问';
      case 'deepseek':
        return 'DeepSeek';
      default:
        return 'AI';
    }
  }

  // Getters
  AISuggestion? get currentSuggestion => _currentSuggestion;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _currentSuggestion != null;

  /// 生成AI建议
  /// [provider] AI提供商: 'kimi', 'qwen', 'deepseek'，不传则使用默认
  Future<void> generateSuggestion({
    required WeatherData weatherData,
    required String city,
    required String cityCode,
    required String scene,
    required String style,
    int? dayIndex, // null表示今天，0-6表示未来7天
    String? provider,
  }) async {
    final date = dayIndex != null 
        ? _getFutureDate(dayIndex)
        : DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    // 检查缓存
    final cached = await _db.getCachedAISuggestion(
      cityCode: cityCode,
      date: date,
      scene: scene,
      style: style,
    );

    if (cached != null) {
      _currentSuggestion = cached;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prompt = _buildPrompt(
        weatherData: weatherData,
        city: city,
        scene: scene,
        style: style,
        dayIndex: dayIndex,
      );

      // 根据当前配置的提供商调用对应API
      ApiResponse<String> response;
      final p = provider ?? AppConfig.defaultAIProvider;
      switch (p) {
        case 'kimi':
          response = await _aiService.generateSuggestionKimi(prompt);
          break;
        case 'qwen':
          response = await _aiService.generateSuggestionQwen(prompt);
          break;
        case 'deepseek':
          response = await _aiService.generateSuggestionDeepSeek(prompt);
          break;
        default:
          response = await _aiService.generateSuggestionKimi(prompt);
      }

      if (response.success && response.data != null) {
        final aiResponse = response.data!;
        
        // 解析AI响应
        final summary = _parseWeatherSummary(aiResponse);
        final travel = _parseTravelSuggestion(aiResponse, scene);
        final dress = _parseDressSuggestion(aiResponse, style);

        _currentSuggestion = AISuggestion(
          city: city,
          date: date,
          weatherSummary: summary,
          travelSuggestion: travel,
          dressSuggestion: dress,
          generatedTime: DateTime.now(),
        );

        _retryCount = 0;

        // 缓存结果
        await _db.cacheAISuggestion(
          cityCode: cityCode,
          date: date,
          scene: scene,
          style: style,
          suggestion: _currentSuggestion!,
        );
      } else {
        _error = response.message ?? 'AI生成失败';
        
        // 重试机制（指数退避）
        if (_retryCount < maxRetries) {
          _retryCount++;
          await Future.delayed(Duration(seconds: _retryCount * 2));
          _isLoading = false;
          notifyListeners();
          return generateSuggestion(
            weatherData: weatherData,
            city: city,
            cityCode: cityCode,
            scene: scene,
            style: style,
            dayIndex: dayIndex,
            provider: provider,
          );
        }
      }
    } catch (e) {
      _error = 'AI服务异常，请稍后重试: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 构建AI提示词
  String _buildPrompt({
    required WeatherData weatherData,
    required String city,
    required String scene,
    required String style,
    int? dayIndex,
  }) {
    final current = weatherData.current;
    final forecast = weatherData.forecast;
    
    final dateStr = dayIndex != null 
        ? _getFutureDate(dayIndex)
        : '今天';

    String weatherInfo;
    if (dayIndex != null && dayIndex < forecast.length) {
      final day = forecast[dayIndex];
      weatherInfo = '''
日期：$dateStr
白天天气：${day.dayWeather}
夜间天气：${day.nightWeather}
最高温度：${day.dayTemp}°C
最低温度：${day.nightTemp}°C
风向风力：${day.windDirection} ${day.windPower}
''';}
    else {
      weatherInfo = '''
日期：$dateStr（当前）
天气：${current.weather}
温度：${current.temperature}°C
体感温度：${current.feelsLike}°C
湿度：${current.humidity}%
风向风力：${current.windDirection} ${current.windPower}
能见度：${current.visibility}km
''';
    }

    final weekForecast = forecast.take(7).map((f) => 
      '${f.date}: ${f.dayWeather}, ${f.nightTemp}°C-${f.dayTemp}°C'
    ).join('\n');

    return '''
请根据以下天气数据，为用户提供出行和穿搭建议。

【城市】$city
【出行场景】$scene
【穿搭偏好】$style

【天气信息】
$weatherInfo

【未来7天预报】
$weekForecast

请按以下格式回答：

【天气总结】
总结：一句话总结天气情况
趋势：温度变化趋势描述
降雨：降雨概率和时段
风力：风力情况
预警：如有恶劣天气请提醒，无则填"无"

【出行建议】（针对$scene场景）
最佳时间：推荐的出行时间段
交通方式：推荐的交通方式
必备物品：列出需要携带的物品，用顿号分隔
注意事项：出行需要注意的事项，用顿号分隔
总体建议：综合建议

【穿搭建议】（针对$style风格，温度${dayIndex != null ? forecast[dayIndex].dayTemp : current.temperature}°C）
上衣：推荐的上装
下装：推荐的下装
鞋子：推荐的鞋子
配饰：推荐的配饰，用顿号分隔
风格：整体风格描述
建议：穿搭注意事项

请确保建议简洁实用，语言自然流畅。
''';
  }

  /// 解析天气总结
  WeatherSummary _parseWeatherSummary(String response) {
    String summary = '';
    String trend = '';
    String rainForecast = '';
    String windForecast = '';
    List<String> alerts = [];

    final lines = response.split('\n');
    bool inWeatherSection = false;

    for (final line in lines) {
      if (line.contains('【天气总结】')) {
        inWeatherSection = true;
        continue;
      }
      if (line.contains('【出行建议】') || line.contains('【穿搭建议】')) {
        inWeatherSection = false;
        continue;
      }

      if (inWeatherSection) {
        if (line.contains('总结：')) {
          summary = line.split('：').skip(1).join('：').trim();
        } else if (line.contains('趋势：')) {
          trend = line.split('：').skip(1).join('：').trim();
        } else if (line.contains('降雨：')) {
          rainForecast = line.split('：').skip(1).join('：').trim();
        } else if (line.contains('风力：')) {
          windForecast = line.split('：').skip(1).join('：').trim();
        } else if (line.contains('预警：')) {
          final alertStr = line.split('：').skip(1).join('：').trim();
          if (alertStr.isNotEmpty && alertStr != '无') {
            alerts = alertStr.split(/[,，、]/).where((s) => s.isNotEmpty).toList();
          }
        }
      }
    }

    return WeatherSummary(
      summary: summary.isNotEmpty ? summary : '天气适宜出行',
      trend: trend,
      rainForecast: rainForecast,
      windForecast: windForecast,
      alerts: alerts,
    );
  }

  /// 解析出行建议
  TravelSuggestion _parseTravelSuggestion(String response, String scene) {
    String bestTime = '';
    String transport = '';
    List<String> essentials = [];
    List<String> notices = [];
    String overallAdvice = '';

    final lines = response.split('\n');
    bool inTravelSection = false;

    for (final line in lines) {
      if (line.contains('【出行建议】')) {
        inTravelSection = true;
        continue;
      }
      if (line.contains('【穿搭建议】')) {
        inTravelSection = false;
        continue;
      }

      if (inTravelSection) {
        if (line.contains('最佳时间：')) {
          bestTime = line.split('：').skip(1).join('：').trim();
        } else if (line.contains('交通方式：')) {
          transport = line.split('：').skip(1).join('：').trim();
        } else if (line.contains('必备物品：')) {
          final items = line.split('：').skip(1).join('：').trim();
          essentials = items.split(/[,，、]/).where((s) => s.isNotEmpty).toList();
        } else if (line.contains('注意事项：')) {
          final items = line.split('：').skip(1).join('：').trim();
          notices = items.split(/[,，、]/).where((s) => s.isNotEmpty).toList();
        } else if (line.contains('总体建议：')) {
          overallAdvice = line.split('：').skip(1).join('：').trim();
        }
      }
    }

    return TravelSuggestion(
      bestTime: bestTime,
      transport: transport,
      essentials: essentials,
      notices: notices,
      overallAdvice: overallAdvice.isNotEmpty ? overallAdvice : '祝您$scene愉快',
    );
  }

  /// 解析穿搭建议
  DressSuggestion _parseDressSuggestion(String response, String style) {
    String top = '';
    String bottom = '';
    String shoes = '';
    List<String> accessories = [];
    String styleDesc = '';
    String advice = '';

    final lines = response.split('\n');
    bool inDressSection = false;

    for (final line in lines) {
      if (line.contains('【穿搭建议】')) {
        inDressSection = true;
        continue;
      }

      if (inDressSection) {
        if (line.contains('上衣：')) {
          top = line.split('：').skip(1).join('：').trim();
        } else if (line.contains('下装：')) {
          bottom = line.split('：').skip(1).join('：').trim();
        } else if (line.contains('鞋子：')) {
          shoes = line.split('：').skip(1).join('：').trim();
        } else if (line.contains('配饰：')) {
          final items = line.split('：').skip(1).join('：').trim();
          accessories = items.split(/[,，、]/).where((s) => s.isNotEmpty).toList();
        } else if (line.contains('风格：')) {
          styleDesc = line.split('：').skip(1).join('：').trim();
        } else if (line.contains('建议：')) {
          advice = line.split('：').skip(1).join('：').trim();
        }
      }
    }

    return DressSuggestion(
      top: top.isNotEmpty ? top : '根据天气选择合适上装',
      bottom: bottom.isNotEmpty ? bottom : '根据天气选择合适下装',
      shoes: shoes.isNotEmpty ? shoes : '舒适透气的鞋子',
      accessories: accessories,
      style: styleDesc.isNotEmpty ? styleDesc : style,
      advice: advice.isNotEmpty ? advice : '注意保暖/防晒',
    );
  }

  /// 获取未来日期
  String _getFutureDate(int days) {
    final date = DateTime.now().add(Duration(days: days));
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// 清除当前建议
  void clearSuggestion() {
    _currentSuggestion = null;
    _error = null;
    _retryCount = 0;
    notifyListeners();
  }

  /// 清除错误
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// 检查是否有风险预警
  bool get hasRiskAlert {
    return _currentSuggestion?.weatherSummary.alerts.isNotEmpty ?? false;
  }

  /// 获取风险等级
  String get riskLevel {
    final alerts = _currentSuggestion?.weatherSummary.alerts ?? [];
    if (alerts.any((a) => a.contains('暴雨') || a.contains('台风'))) return '高';
    if (alerts.any((a) => a.contains('大雨') || a.contains('高温'))) return '中';
    if (alerts.isNotEmpty) return '低';
    return '无';
  }
}
