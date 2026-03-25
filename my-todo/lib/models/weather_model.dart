import 'package:equatable/equatable.dart';

/// 实时天气数据
class CurrentWeather extends Equatable {
  final String city;
  final String cityCode;
  final String weather;
  final String weatherCode;
  final double temperature;
  final double feelsLike;
  final String humidity;
  final String windDirection;
  final String windPower;
  final String pressure;
  final String visibility;
  final String updateTime;

  const CurrentWeather({
    required this.city,
    required this.cityCode,
    required this.weather,
    required this.weatherCode,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windDirection,
    required this.windPower,
    required this.pressure,
    required this.visibility,
    required this.updateTime,
  });

  factory CurrentWeather.fromAmapJson(Map<String, dynamic> json) {
    final lives = json['lives']?[0];
    if (lives == null) throw Exception('No weather data');
    
    return CurrentWeather(
      city: lives['city'] ?? '',
      cityCode: lives['adcode'] ?? '',
      weather: lives['weather'] ?? '未知',
      weatherCode: lives['weather'] ?? '',
      temperature: double.tryParse(lives['temperature'] ?? '0') ?? 0,
      feelsLike: double.tryParse(lives['temperature'] ?? '0') ?? 0,
      humidity: lives['humidity'] ?? '0',
      windDirection: lives['winddirection'] ?? '',
      windPower: lives['windpower'] ?? '',
      pressure: lives['pressure'] ?? '',
      visibility: lives['visibility'] ?? '',
      updateTime: lives['reporttime'] ?? '',
    );
  }

  factory CurrentWeather.fromQWeatherJson(Map<String, dynamic> json) {
    final now = json['now'];
    return CurrentWeather(
      city: json['location']?['name'] ?? '',
      cityCode: json['location']?['id'] ?? '',
      weather: now['text'] ?? '未知',
      weatherCode: now['icon'] ?? '',
      temperature: double.tryParse(now['temp'] ?? '0') ?? 0,
      feelsLike: double.tryParse(now['feelsLike'] ?? '0') ?? 0,
      humidity: now['humidity'] ?? '0',
      windDirection: now['windDir'] ?? '',
      windPower: now['windScale'] ?? '',
      pressure: now['pressure'] ?? '',
      visibility: now['vis'] ?? '',
      updateTime: now['obsTime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'city': city,
    'cityCode': cityCode,
    'weather': weather,
    'weatherCode': weatherCode,
    'temperature': temperature,
    'feelsLike': feelsLike,
    'humidity': humidity,
    'windDirection': windDirection,
    'windPower': windPower,
    'pressure': pressure,
    'visibility': visibility,
    'updateTime': updateTime,
  };

  factory CurrentWeather.fromJson(Map<String, dynamic> json) => CurrentWeather(
    city: json['city'] ?? '',
    cityCode: json['cityCode'] ?? '',
    weather: json['weather'] ?? '',
    weatherCode: json['weatherCode'] ?? '',
    temperature: (json['temperature'] as num?)?.toDouble() ?? 0,
    feelsLike: (json['feelsLike'] as num?)?.toDouble() ?? 0,
    humidity: json['humidity'] ?? '',
    windDirection: json['windDirection'] ?? '',
    windPower: json['windPower'] ?? '',
    pressure: json['pressure'] ?? '',
    visibility: json['visibility'] ?? '',
    updateTime: json['updateTime'] ?? '',
  );

  @override
  List<Object?> get props => [
    city, cityCode, weather, weatherCode, temperature, 
    feelsLike, humidity, windDirection, windPower, 
    pressure, visibility, updateTime
  ];
}

/// 天气预报（单天）
class DailyForecast extends Equatable {
  final String date;
  final String dayWeather;
  final String nightWeather;
  final double dayTemp;
  final double nightTemp;
  final String windDirection;
  final String windPower;

  const DailyForecast({
    required this.date,
    required this.dayWeather,
    required this.nightWeather,
    required this.dayTemp,
    required this.nightTemp,
    required this.windDirection,
    required this.windPower,
  });

  factory DailyForecast.fromAmapJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: json['date'] ?? '',
      dayWeather: json['dayweather'] ?? '',
      nightWeather: json['nightweather'] ?? '',
      dayTemp: double.tryParse(json['daytemp'] ?? '0') ?? 0,
      nightTemp: double.tryParse(json['nighttemp'] ?? '0') ?? 0,
      windDirection: json['daywind'] ?? '',
      windPower: json['daypower'] ?? '',
    );
  }

  factory DailyForecast.fromQWeatherJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: json['fxDate'] ?? '',
      dayWeather: json['textDay'] ?? '',
      nightWeather: json['textNight'] ?? '',
      dayTemp: double.tryParse(json['tempMax'] ?? '0') ?? 0,
      nightTemp: double.tryParse(json['tempMin'] ?? '0') ?? 0,
      windDirection: json['windDirDay'] ?? '',
      windPower: json['windScaleDay'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'dayWeather': dayWeather,
    'nightWeather': nightWeather,
    'dayTemp': dayTemp,
    'nightTemp': nightTemp,
    'windDirection': windDirection,
    'windPower': windPower,
  };

  factory DailyForecast.fromJson(Map<String, dynamic> json) => DailyForecast(
    date: json['date'] ?? '',
    dayWeather: json['dayWeather'] ?? '',
    nightWeather: json['nightWeather'] ?? '',
    dayTemp: (json['dayTemp'] as num?)?.toDouble() ?? 0,
    nightTemp: (json['nightTemp'] as num?)?.toDouble() ?? 0,
    windDirection: json['windDirection'] ?? '',
    windPower: json['windPower'] ?? '',
  );

  @override
  List<Object?> get props => [date, dayWeather, nightWeather, dayTemp, nightTemp];
}

/// 生活指数
class LifeIndex extends Equatable {
  final String uv;           // 紫外线
  final String airQuality;   // 空气质量
  final String dress;        // 穿衣
  final String carWash;      // 洗车
  final String sport;        // 运动
  final String travel;       // 旅游
  final String cold;         // 感冒

  const LifeIndex({
    required this.uv,
    required this.airQuality,
    required this.dress,
    required this.carWash,
    required this.sport,
    required this.travel,
    required this.cold,
  });

  factory LifeIndex.fromAmapJson(Map<String, dynamic> json) {
    final casts = json['forecasts']?[0]?['casts']?[0];
    return LifeIndex(
      uv: casts?['uv'] ?? '',
      airQuality: '', // 高德需要单独接口
      dress: '',
      carWash: '',
      sport: '',
      travel: '',
      cold: '',
    );
  }

  Map<String, dynamic> toJson() => {
    'uv': uv,
    'airQuality': airQuality,
    'dress': dress,
    'carWash': carWash,
    'sport': sport,
    'travel': travel,
    'cold': cold,
  };

  factory LifeIndex.fromJson(Map<String, dynamic> json) => LifeIndex(
    uv: json['uv'] ?? '',
    airQuality: json['airQuality'] ?? '',
    dress: json['dress'] ?? '',
    carWash: json['carWash'] ?? '',
    sport: json['sport'] ?? '',
    travel: json['travel'] ?? '',
    cold: json['cold'] ?? '',
  );

  @override
  List<Object?> get props => [uv, airQuality, dress, carWash, sport, travel, cold];
}

/// 完整天气数据
class WeatherData extends Equatable {
  final CurrentWeather current;
  final List<DailyForecast> forecast;
  final LifeIndex? lifeIndex;

  const WeatherData({
    required this.current,
    required this.forecast,
    this.lifeIndex,
  });

  WeatherData copyWith({
    CurrentWeather? current,
    List<DailyForecast>? forecast,
    LifeIndex? lifeIndex,
  }) => WeatherData(
    current: current ?? this.current,
    forecast: forecast ?? this.forecast,
    lifeIndex: lifeIndex ?? this.lifeIndex,
  );

  Map<String, dynamic> toJson() => {
    'current': current.toJson(),
    'forecast': forecast.map((f) => f.toJson()).toList(),
    'lifeIndex': lifeIndex?.toJson(),
  };

  factory WeatherData.fromJson(Map<String, dynamic> json) => WeatherData(
    current: CurrentWeather.fromJson(json['current']),
    forecast: (json['forecast'] as List?)
        ?.map((e) => DailyForecast.fromJson(e))
        .toList() ?? [],
    lifeIndex: json['lifeIndex'] != null 
        ? LifeIndex.fromJson(json['lifeIndex']) 
        : null,
  );

  @override
  List<Object?> get props => [current, forecast, lifeIndex];
}
