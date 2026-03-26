import 'package:flutter/material.dart';

import '../models/city_model.dart';
import '../services/api_service.dart';
import '../services/web_scraper_service.dart';
import '../services/database_service.dart';

/// 城市状态管理
class CityProvider extends ChangeNotifier {
  final WeatherApiService _weatherApi = WeatherApiService.instance;
  final WebScraperService _scraperService = WebScraperService.instance;
  final WeatherServiceWithFallback _fallbackService = WeatherServiceWithFallback.instance;
  final DatabaseService _db = DatabaseService.instance;

  // 状态
  List<City> _favoriteCities = [];
  List<SearchHistory> _searchHistory = [];
  List<City> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<City> get favoriteCities => _favoriteCities;
  List<SearchHistory> get searchHistory => _searchHistory;
  List<City> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get error => _error;

  CityProvider() {
    loadFavoriteCities();
    loadSearchHistory();
  }

  /// 加载收藏城市
  Future<void> loadFavoriteCities() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favoriteCities = await _db.getFavoriteCities();
      _error = null;
    } catch (e) {
      _error = '加载收藏城市失败';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 加载搜索历史
  Future<void> loadSearchHistory() async {
    try {
      _searchHistory = await _db.getSearchHistory();
      notifyListeners();
    } catch (e) {
      // 搜索历史加载失败不影响主要功能
    }
  }

  /// 搜索城市（支持API和网页回退）
  Future<void> searchCity(String keyword) async {
    if (keyword.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 使用fallback服务（优先API，失败自动回退）
      final response = await _fallbackService.searchCity(keyword);
      
      if (response.success && response.data != null) {
        _searchResults = response.data!;

        // 检查是否已收藏
        for (var i = 0; i < _searchResults.length; i++) {
          final isFav = await _db.isCityFavorite(_searchResults[i].code);
          _searchResults[i] = _searchResults[i].copyWith(isFavorite: isFav);
        }
      } else {
        _searchResults = [];
        _error = response.message ?? '搜索失败';
      }
    } catch (e) {
      _searchResults = [];
      _error = '网络异常，请重试';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 添加收藏
  Future<void> addToFavorites(City city) async {
    try {
      await _db.addFavoriteCity(city.copyWith(isFavorite: true));
      await loadFavoriteCities();
      
      // 更新搜索结果中的收藏状态
      final index = _searchResults.indexWhere((c) => c.code == city.code);
      if (index != -1) {
        _searchResults[index] = _searchResults[index].copyWith(isFavorite: true);
        notifyListeners();
      }
    } catch (e) {
      _error = '添加收藏失败';
      notifyListeners();
    }
  }

  /// 取消收藏
  Future<void> removeFromFavorites(String cityCode) async {
    try {
      await _db.removeFavoriteCity(cityCode);
      _favoriteCities.removeWhere((c) => c.code == cityCode);
      
      // 更新搜索结果中的收藏状态
      final index = _searchResults.indexWhere((c) => c.code == cityCode);
      if (index != -1) {
        _searchResults[index] = _searchResults[index].copyWith(isFavorite: false);
      }
      
      notifyListeners();
    } catch (e) {
      _error = '取消收藏失败';
      notifyListeners();
    }
  }

  /// 切换收藏状态
  Future<void> toggleFavorite(City city) async {
    if (city.isFavorite) {
      await removeFromFavorites(city.code);
    } else {
      await addToFavorites(city);
    }
  }

  /// 添加搜索历史
  Future<void> addToHistory(String cityCode, String cityName) async {
    try {
      await _db.addSearchHistory(cityCode, cityName);
      await loadSearchHistory();
    } catch (e) {
      // 不影响主要功能
    }
  }

  /// 清空搜索历史
  Future<void> clearHistory() async {
    try {
      await _db.clearSearchHistory();
      _searchHistory = [];
      notifyListeners();
    } catch (e) {
      _error = '清空历史失败';
      notifyListeners();
    }
  }

  /// 清除搜索结果
  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }

  /// 清除错误信息
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
