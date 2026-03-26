import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../config/app_config.dart';

/// API响应封装
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? code;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.code,
  });

  factory ApiResponse.success(T data) => ApiResponse(
    success: true,
    data: data,
  );

  factory ApiResponse.error(String message, {int? code}) => ApiResponse(
    success: false,
    message: message,
    code: code,
  );
}

/// HTTP请求服务
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  static ApiService get instance => _instance;

  late Dio _dio;
  final Logger _logger = Logger();

  void initialize() {
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // 添加拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.d('Request: ${options.method} ${options.uri}');
        _logger.d('Params: ${options.queryParameters}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.d('Response: ${response.statusCode} ${response.data}');
        return handler.next(response);
      },
      onError: (error, handler) {
        _logger.e('Error: ${error.message}', error: error);
        return handler.next(error);
      },
    ));
  }

  /// GET请求
  Future<ApiResponse<T>> get<T>({
    required String url,
    Map<String, dynamic>? params,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: params,
        options: options,
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(response.data as T);
      } else {
        return ApiResponse.error(
          '请求失败: ${response.statusCode}',
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        _handleDioError(e),
        code: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResponse.error('网络异常: $e');
    }
  }

  /// POST请求
  Future<ApiResponse<T>> post<T>({
    required String url,
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        queryParameters: params,
        options: options,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(response.data as T);
      } else {
        return ApiResponse.error(
          '请求失败: ${response.statusCode}',
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        _handleDioError(e),
        code: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResponse.error('网络异常: $e');
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return '连接超时，请检查网络';
      case DioExceptionType.sendTimeout:
        return '发送超时，请重试';
      case DioExceptionType.receiveTimeout:
        return '接收超时，请重试';
      case DioExceptionType.badCertificate:
        return '证书验证失败';
      case DioExceptionType.badResponse:
        return '服务器响应错误: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return '请求已取消';
      case DioExceptionType.connectionError:
        return '网络连接失败';
      case DioExceptionType.unknown:
        return '网络异常: ${error.message}';
      default:
        return '网络异常，请重试';
    }
  }
}

/// 天气API服务
class WeatherApiService {
  static final WeatherApiService _instance = WeatherApiService._internal();
  factory WeatherApiService() => _instance;
  WeatherApiService._internal();

  static WeatherApiService get instance => _instance;

  final ApiService _api = ApiService.instance;

  /// 获取实时天气（高德API）
  Future<ApiResponse<Map<String, dynamic>>> getCurrentWeatherAmap(String cityCode) async {
    return await _api.get<Map<String, dynamic>>(
      url: '${AppConfig.amapBaseUrl}/weatherInfo',
      params: {
        'key': AppConfig.amapWeatherKey,
        'city': cityCode,
        'extensions': 'base',
      },
    );
  }

  /// 获取天气预报（高德API）
  Future<ApiResponse<Map<String, dynamic>>> getForecastAmap(String cityCode) async {
    return await _api.get<Map<String, dynamic>>(
      url: '${AppConfig.amapBaseUrl}/weatherInfo',
      params: {
        'key': AppConfig.amapWeatherKey,
        'city': cityCode,
        'extensions': 'all',
      },
    );
  }

  /// 城市搜索（高德API）
  Future<ApiResponse<Map<String, dynamic>>> searchCityAmap(String keywords) async {
    return await _api.get<Map<String, dynamic>>(
      url: 'https://restapi.amap.com/v3/config/district',
      params: {
        'key': AppConfig.amapWeatherKey,
        'keywords': keywords,
        'subdistrict': 0,
        'extensions': 'base',
      },
    );
  }

  /// 获取实时天气（和风天气API）
  Future<ApiResponse<Map<String, dynamic>>> getCurrentWeatherQWeather(String location) async {
    return await _api.get<Map<String, dynamic>>(
      url: '${AppConfig.qweatherBaseUrl}/weather/now',
      params: {
        'key': AppConfig.qweatherKey,
        'location': location,
      },
    );
  }

  /// 获取7天预报（和风天气API）
  Future<ApiResponse<Map<String, dynamic>>> get7DayForecastQWeather(String location) async {
    return await _api.get<Map<String, dynamic>>(
      url: '${AppConfig.qweatherBaseUrl}/weather/7d',
      params: {
        'key': AppConfig.qweatherKey,
        'location': location,
      },
    );
  }

  /// 城市搜索（和风天气API）
  Future<ApiResponse<Map<String, dynamic>>> searchCityQWeather(String query) async {
    return await _api.get<Map<String, dynamic>>(
      url: 'https://geoapi.qweather.com/v2/city/lookup',
      params: {
        'key': AppConfig.qweatherKey,
        'location': query,
      },
    );
  }
}

/// AI API服务
class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  static AIService get instance => _instance;

  final ApiService _api = ApiService.instance;

  /// 根据配置生成建议
  /// [provider] 可选值: 'kimi', 'qwen', 'deepseek'
  Future<ApiResponse<String>> generateSuggestion(String prompt, {String? provider}) async {
    final p = provider ?? AppConfig.defaultAIProvider;
    switch (p) {
      case 'kimi':
        return await generateSuggestionKimi(prompt);
      case 'qwen':
        return await generateSuggestionQwen(prompt);
      case 'deepseek':
        return await generateSuggestionDeepSeek(prompt);
      default:
        return await generateSuggestionKimi(prompt);
    }
  }

  /// Kimi (Moonshot AI) API
  /// 文档: https://platform.moonshot.cn/docs
  Future<ApiResponse<String>> generateSuggestionKimi(String prompt) async {
    final response = await _api.post<Map<String, dynamic>>(
      url: '${AppConfig.kimiBaseUrl}/chat/completions',
      data: {
        'model': AppConfig.kimiModel,
        'messages': [
          {
            'role': 'system',
            'content': '你是一个专业的天气出行穿搭助手。请根据提供的天气数据，给出简洁实用的出行和穿搭建议。回答要简洁明了，使用短句，不要太长。'
          },
          {
            'role': 'user',
            'content': prompt
          }
        ],
        'temperature': 0.7,
        'max_tokens': 800,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${AppConfig.kimiApiKey}',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.success) {
      try {
        final content = response.data?['choices']?[0]?['message']?['content'];
        return ApiResponse.success(content ?? '');
      } catch (e) {
        return ApiResponse.error('解析Kimi响应失败: $e');
      }
    } else {
      return ApiResponse.error(response.message ?? 'Kimi AI请求失败');
    }
  }

  /// 通义千问 API
  Future<ApiResponse<String>> generateSuggestionQwen(String prompt) async {
    final response = await _api.post<Map<String, dynamic>>(
      url: '${AppConfig.qwenBaseUrl}/services/aigc/text-generation/generation',
      data: {
        'model': AppConfig.qwenModel,
        'input': {
          'messages': [
            {
              'role': 'system',
              'content': '你是一个专业的天气出行穿搭助手。请根据提供的天气数据，给出简洁实用的出行和穿搭建议。回答要简洁明了，使用短句。'
            },
            {
              'role': 'user',
              'content': prompt
            }
          ]
        },
        'parameters': {
          'result_format': 'message',
          'max_tokens': 800,
          'temperature': 0.7,
        }
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${AppConfig.qwenApiKey}',
        },
      ),
    );

    if (response.success) {
      try {
        final content = response.data?['output']?['choices']?[0]?['message']?['content'];
        return ApiResponse.success(content ?? '');
      } catch (e) {
        return ApiResponse.error('解析通义千问响应失败: $e');
      }
    } else {
      return ApiResponse.error(response.message ?? '通义千问请求失败');
    }
  }

  /// DeepSeek API
  Future<ApiResponse<String>> generateSuggestionDeepSeek(String prompt) async {
    final response = await _api.post<Map<String, dynamic>>(
      url: '${AppConfig.deepseekBaseUrl}/chat/completions',
      data: {
        'model': AppConfig.deepseekModel,
        'messages': [
          {
            'role': 'system',
            'content': '你是一个专业的天气出行穿搭助手。请根据提供的天气数据，给出简洁实用的出行和穿搭建议。'
          },
          {
            'role': 'user',
            'content': prompt
          }
        ],
        'max_tokens': 800,
        'temperature': 0.7,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${AppConfig.deepseekApiKey}',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.success) {
      try {
        final content = response.data?['choices']?[0]?['message']?['content'];
        return ApiResponse.success(content ?? '');
      } catch (e) {
        return ApiResponse.error('解析DeepSeek响应失败: $e');
      }
    } else {
      return ApiResponse.error(response.message ?? 'DeepSeek请求失败');
    }
  }
}
