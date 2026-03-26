import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../config/app_config.dart';
import '../models/city_model.dart';
import '../models/weather_model.dart';
import '../models/ai_suggestion_model.dart';

/// SQLite数据库服务
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static DatabaseService get instance => _instance;

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'weather_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 收藏城市表
    await db.execute('''
      CREATE TABLE favorite_cities (
        code TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        province TEXT NOT NULL,
        district TEXT,
        longitude REAL,
        latitude REAL,
        added_time INTEGER
      )
    ''');

    // 搜索历史表
    await db.execute('''
      CREATE TABLE search_history (
        city_code TEXT PRIMARY KEY,
        city_name TEXT NOT NULL,
        search_time INTEGER NOT NULL
      )
    ''');

    // 天气缓存表
    await db.execute('''
      CREATE TABLE weather_cache (
        city_code TEXT PRIMARY KEY,
        city_name TEXT NOT NULL,
        weather_data TEXT NOT NULL,
        cache_time INTEGER NOT NULL
      )
    ''');

    // AI建议缓存表
    await db.execute('''
      CREATE TABLE ai_suggestion_cache (
        city_code TEXT NOT NULL,
        date TEXT NOT NULL,
        scene TEXT NOT NULL,
        style TEXT NOT NULL,
        suggestion_data TEXT NOT NULL,
        cache_time INTEGER NOT NULL,
        PRIMARY KEY (city_code, date, scene, style)
      )
    ''');

    // 设置表
    await db.execute('''
      CREATE TABLE app_settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 数据库升级处理
  }

  Future<void> initialize() async {
    await database;
  }

  // ==================== 收藏城市操作 ====================

  /// 添加收藏城市
  Future<void> addFavoriteCity(City city) async {
    final db = await database;
    await db.insert(
      'favorite_cities',
      {
        ...city.toJson(),
        'added_time': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 删除收藏城市
  Future<void> removeFavoriteCity(String cityCode) async {
    final db = await database;
    await db.delete(
      'favorite_cities',
      where: 'code = ?',
      whereArgs: [cityCode],
    );
  }

  /// 获取所有收藏城市
  Future<List<City>> getFavoriteCities() async {
    final db = await database;
    final maps = await db.query(
      'favorite_cities',
      orderBy: 'added_time DESC',
    );
    return maps.map((map) => City.fromJson({
      ...map,
      'isFavorite': true,
    })).toList();
  }

  /// 检查城市是否已收藏
  Future<bool> isCityFavorite(String cityCode) async {
    final db = await database;
    final result = await db.query(
      'favorite_cities',
      where: 'code = ?',
      whereArgs: [cityCode],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  // ==================== 搜索历史操作 ====================

  /// 添加搜索历史
  Future<void> addSearchHistory(String cityCode, String cityName) async {
    final db = await database;
    
    // 先删除旧的记录
    await db.delete(
      'search_history',
      where: 'city_code = ?',
      whereArgs: [cityCode],
    );

    // 插入新记录
    await db.insert(
      'search_history',
      {
        'city_code': cityCode,
        'city_name': cityName,
        'search_time': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // 清理超过限制的历史记录
    await _cleanupOldHistory();
  }

  /// 获取搜索历史
  Future<List<SearchHistory>> getSearchHistory({int limit = 10}) async {
    final db = await database;
    final maps = await db.query(
      'search_history',
      orderBy: 'search_time DESC',
      limit: limit,
    );
    return maps.map((map) => SearchHistory.fromJson({
      'cityCode': map['city_code'],
      'cityName': map['city_name'],
      'searchTime': map['search_time'],
    })).toList();
  }

  /// 清理旧的历史记录
  Future<void> _cleanupOldHistory() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM search_history')
    ) ?? 0;

    if (count > AppConfig.maxHistoryCount) {
      final oldestToKeep = await db.query(
        'search_history',
        orderBy: 'search_time DESC',
        limit: 1,
        offset: AppConfig.maxHistoryCount - 1,
      );
      
      if (oldestToKeep.isNotEmpty) {
        final thresholdTime = oldestToKeep.first['search_time'] as int;
        await db.delete(
          'search_history',
          where: 'search_time < ?',
          whereArgs: [thresholdTime],
        );
      }
    }
  }

  /// 清空搜索历史
  Future<void> clearSearchHistory() async {
    final db = await database;
    await db.delete('search_history');
  }

  // ==================== 天气缓存操作 ====================

  /// 保存天气缓存
  Future<void> cacheWeather(String cityCode, WeatherData weather) async {
    final db = await database;
    await db.insert(
      'weather_cache',
      {
        'city_code': cityCode,
        'city_name': weather.current.city,
        'weather_data': jsonEncode(weather.toJson()),
        'cache_time': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 获取天气缓存
  Future<WeatherData?> getCachedWeather(String cityCode) async {
    final db = await database;
    final maps = await db.query(
      'weather_cache',
      where: 'city_code = ?',
      whereArgs: [cityCode],
      limit: 1,
    );

    if (maps.isEmpty) return null;

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(
      maps.first['cache_time'] as int
    );
    final now = DateTime.now();

    // 检查缓存是否过期
    if (now.difference(cacheTime).inHours > AppConfig.cacheValidHours) {
      return null;
    }

    try {
      final weatherData = jsonDecode(maps.first['weather_data'] as String);
      return WeatherData.fromJson(weatherData);
    } catch (e) {
      return null;
    }
  }

  /// 清除过期缓存
  Future<void> clearExpiredCache() async {
    final db = await database;
    final expirationTime = DateTime.now()
        .subtract(Duration(hours: AppConfig.cacheValidHours))
        .millisecondsSinceEpoch;
    
    await db.delete(
      'weather_cache',
      where: 'cache_time < ?',
      whereArgs: [expirationTime],
    );
  }

  // ==================== AI建议缓存操作 ====================

  /// 缓存AI建议
  Future<void> cacheAISuggestion({
    required String cityCode,
    required String date,
    required String scene,
    required String style,
    required AISuggestion suggestion,
  }) async {
    final db = await database;
    await db.insert(
      'ai_suggestion_cache',
      {
        'city_code': cityCode,
        'date': date,
        'scene': scene,
        'style': style,
        'suggestion_data': jsonEncode(suggestion.toJson()),
        'cache_time': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 获取缓存的AI建议
  Future<AISuggestion?> getCachedAISuggestion({
    required String cityCode,
    required String date,
    required String scene,
    required String style,
  }) async {
    final db = await database;
    final maps = await db.query(
      'ai_suggestion_cache',
      where: 'city_code = ? AND date = ? AND scene = ? AND style = ?',
      whereArgs: [cityCode, date, scene, style],
      limit: 1,
    );

    if (maps.isEmpty) return null;

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(
      maps.first['cache_time'] as int
    );
    final now = DateTime.now();

    // AI建议缓存30分钟
    if (now.difference(cacheTime).inMinutes > 30) {
      return null;
    }

    try {
      final suggestionData = jsonDecode(maps.first['suggestion_data'] as String);
      return AISuggestion.fromJson(suggestionData);
    } catch (e) {
      return null;
    }
  }

  // ==================== 设置操作 ====================

  /// 保存设置
  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'app_settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 获取设置
  Future<String?> getSetting(String key) async {
    final db = await database;
    final maps = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    return maps.isEmpty ? null : maps.first['value'] as String;
  }

  /// 删除设置
  Future<void> deleteSetting(String key) async {
    final db = await database;
    await db.delete(
      'app_settings',
      where: 'key = ?',
      whereArgs: [key],
    );
  }

  // ==================== 数据库管理 ====================

  /// 关闭数据库
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  /// 清空所有数据
  Future<void> clearAll() async {
    final db = await database;
    await db.delete('favorite_cities');
    await db.delete('search_history');
    await db.delete('weather_cache');
    await db.delete('ai_suggestion_cache');
    await db.delete('app_settings');
  }
}
