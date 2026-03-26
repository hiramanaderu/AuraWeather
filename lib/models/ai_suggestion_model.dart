import 'package:equatable/equatable.dart';

/// AI天气总结
class WeatherSummary extends Equatable {
  final String summary;          // 一句话总结
  final String trend;            // 温度趋势
  final String rainForecast;     // 降雨预测
  final String windForecast;     // 风力预测
  final List<String> alerts;     // 预警信息

  const WeatherSummary({
    required this.summary,
    required this.trend,
    required this.rainForecast,
    required this.windForecast,
    required this.alerts,
  });

  factory WeatherSummary.fromAIResponse(String response) {
    // 解析AI返回的JSON格式
    try {
      final lines = response.split('\n');
      String summary = '';
      String trend = '';
      String rainForecast = '';
      String windForecast = '';
      List<String> alerts = [];

      for (final line in lines) {
        if (line.contains('总结：')) summary = line.split('：')[1].trim();
        if (line.contains('趋势：')) trend = line.split('：')[1].trim();
        if (line.contains('降雨：')) rainForecast = line.split('：')[1].trim();
        if (line.contains('风力：')) windForecast = line.split('：')[1].trim();
        if (line.contains('预警：')) {
          final alertStr = line.split('：')[1].trim();
          if (alertStr.isNotEmpty && alertStr != '无') {
            alerts = alertStr.split('，');
          }
        }
      }

      return WeatherSummary(
        summary: summary.isNotEmpty ? summary : response,
        trend: trend,
        rainForecast: rainForecast,
        windForecast: windForecast,
        alerts: alerts,
      );
    } catch (e) {
      return WeatherSummary(
        summary: response,
        trend: '',
        rainForecast: '',
        windForecast: '',
        alerts: [],
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'summary': summary,
    'trend': trend,
    'rainForecast': rainForecast,
    'windForecast': windForecast,
    'alerts': alerts,
  };

  @override
  List<Object?> get props => [summary, trend, rainForecast, windForecast, alerts];
}

/// AI出行建议
class TravelSuggestion extends Equatable {
  final String bestTime;         // 最佳出行时间
  final String transport;        // 推荐交通方式
  final List<String> essentials; // 必备物品
  final List<String> notices;    // 注意事项
  final String overallAdvice;    // 总体建议

  const TravelSuggestion({
    required this.bestTime,
    required this.transport,
    required this.essentials,
    required this.notices,
    required this.overallAdvice,
  });

  factory TravelSuggestion.fromAIResponse(String response) {
    try {
      final lines = response.split('\n');
      String bestTime = '';
      String transport = '';
      List<String> essentials = [];
      List<String> notices = [];
      String overallAdvice = '';

      for (final line in lines) {
        if (line.contains('最佳时间：')) bestTime = line.split('：')[1].trim();
        if (line.contains('交通方式：')) transport = line.split('：')[1].trim();
        if (line.contains('必备物品：')) {
          final items = line.split('：')[1].trim();
          essentials = items.split('、').where((s) => s.isNotEmpty).toList();
        }
        if (line.contains('注意事项：')) {
          final items = line.split('：')[1].trim();
          notices = items.split('、').where((s) => s.isNotEmpty).toList();
        }
        if (line.contains('总体建议：')) overallAdvice = line.split('：')[1].trim();
      }

      return TravelSuggestion(
        bestTime: bestTime,
        transport: transport,
        essentials: essentials,
        notices: notices,
        overallAdvice: overallAdvice.isNotEmpty ? overallAdvice : response,
      );
    } catch (e) {
      return TravelSuggestion(
        bestTime: '',
        transport: '',
        essentials: [],
        notices: [],
        overallAdvice: response,
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'bestTime': bestTime,
    'transport': transport,
    'essentials': essentials,
    'notices': notices,
    'overallAdvice': overallAdvice,
  };

  @override
  List<Object?> get props => [bestTime, transport, essentials, notices, overallAdvice];
}

/// AI穿搭建议
class DressSuggestion extends Equatable {
  final String top;              // 上衣
  final String bottom;           // 下装
  final String shoes;            // 鞋子
  final List<String> accessories; // 配饰
  final String style;            // 风格描述
  final String advice;           // 穿搭建议

  const DressSuggestion({
    required this.top,
    required this.bottom,
    required this.shoes,
    required this.accessories,
    required this.style,
    required this.advice,
  });

  factory DressSuggestion.fromAIResponse(String response) {
    try {
      final lines = response.split('\n');
      String top = '';
      String bottom = '';
      String shoes = '';
      List<String> accessories = [];
      String style = '';
      String advice = '';

      for (final line in lines) {
        if (line.contains('上衣：')) top = line.split('：')[1].trim();
        if (line.contains('下装：')) bottom = line.split('：')[1].trim();
        if (line.contains('鞋子：')) shoes = line.split('：')[1].trim();
        if (line.contains('配饰：')) {
          final items = line.split('：')[1].trim();
          accessories = items.split('、').where((s) => s.isNotEmpty).toList();
        }
        if (line.contains('风格：')) style = line.split('：')[1].trim();
        if (line.contains('建议：')) advice = line.split('：')[1].trim();
      }

      return DressSuggestion(
        top: top,
        bottom: bottom,
        shoes: shoes,
        accessories: accessories,
        style: style,
        advice: advice.isNotEmpty ? advice : response,
      );
    } catch (e) {
      return DressSuggestion(
        top: '',
        bottom: '',
        shoes: '',
        accessories: [],
        style: '',
        advice: response,
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'top': top,
    'bottom': bottom,
    'shoes': shoes,
    'accessories': accessories,
    'style': style,
    'advice': advice,
  };

  String get fullOutfit => '$top + $bottom + $鞋子';

  @override
  List<Object?> get props => [top, bottom, shoes, accessories, style, advice];
}

/// AI完整建议
class AISuggestion extends Equatable {
  final String city;
  final String date;
  final WeatherSummary weatherSummary;
  final TravelSuggestion travelSuggestion;
  final DressSuggestion dressSuggestion;
  final DateTime generatedTime;

  const AISuggestion({
    required this.city,
    required this.date,
    required this.weatherSummary,
    required this.travelSuggestion,
    required this.dressSuggestion,
    required this.generatedTime,
  });

  AISuggestion copyWith({
    String? city,
    String? date,
    WeatherSummary? weatherSummary,
    TravelSuggestion? travelSuggestion,
    DressSuggestion? dressSuggestion,
    DateTime? generatedTime,
  }) => AISuggestion(
    city: city ?? this.city,
    date: date ?? this.date,
    weatherSummary: weatherSummary ?? this.weatherSummary,
    travelSuggestion: travelSuggestion ?? this.travelSuggestion,
    dressSuggestion: dressSuggestion ?? this.dressSuggestion,
    generatedTime: generatedTime ?? this.generatedTime,
  );

  Map<String, dynamic> toJson() => {
    'city': city,
    'date': date,
    'weatherSummary': weatherSummary.toJson(),
    'travelSuggestion': travelSuggestion.toJson(),
    'dressSuggestion': dressSuggestion.toJson(),
    'generatedTime': generatedTime.millisecondsSinceEpoch,
  };

  factory AISuggestion.fromJson(Map<String, dynamic> json) => AISuggestion(
    city: json['city'] ?? '',
    date: json['date'] ?? '',
    weatherSummary: WeatherSummary(
      summary: json['weatherSummary']?['summary'] ?? '',
      trend: json['weatherSummary']?['trend'] ?? '',
      rainForecast: json['weatherSummary']?['rainForecast'] ?? '',
      windForecast: json['weatherSummary']?['windForecast'] ?? '',
      alerts: (json['weatherSummary']?['alerts'] as List?)?.cast<String>() ?? [],
    ),
    travelSuggestion: TravelSuggestion(
      bestTime: json['travelSuggestion']?['bestTime'] ?? '',
      transport: json['travelSuggestion']?['transport'] ?? '',
      essentials: (json['travelSuggestion']?['essentials'] as List?)?.cast<String>() ?? [],
      notices: (json['travelSuggestion']?['notices'] as List?)?.cast<String>() ?? [],
      overallAdvice: json['travelSuggestion']?['overallAdvice'] ?? '',
    ),
    dressSuggestion: DressSuggestion(
      top: json['dressSuggestion']?['top'] ?? '',
      bottom: json['dressSuggestion']?['bottom'] ?? '',
      shoes: json['dressSuggestion']?['shoes'] ?? '',
      accessories: (json['dressSuggestion']?['accessories'] as List?)?.cast<String>() ?? [],
      style: json['dressSuggestion']?['style'] ?? '',
      advice: json['dressSuggestion']?['advice'] ?? '',
    ),
    generatedTime: DateTime.fromMillisecondsSinceEpoch(
      json['generatedTime'] ?? DateTime.now().millisecondsSinceEpoch
    ),
  );

  @override
  List<Object?> get props => [city, date, weatherSummary, travelSuggestion, dressSuggestion];
}
