import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../providers/weather_provider.dart';
import '../../providers/city_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/ai_provider.dart';
import '../../utils/extensions.dart';
import '../search/search_screen.dart';
import '../favorites/favorites_screen.dart';
import '../settings/settings_screen.dart';
import 'widgets/current_weather_card.dart';
import 'widgets/forecast_list.dart';
import 'widgets/ai_summary_card.dart';
import 'widgets/ai_suggestion_panel.dart';
import 'widgets/life_index_grid.dart';

/// 首页
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RefreshController _refreshController = RefreshController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final settings = context.read<SettingsProvider>();
    final weather = context.read<WeatherProvider>();
    final city = context.read<CityProvider>();
    
    // 加载收藏城市
    await city.loadFavoriteCities();
    
    // 加载天气数据
    await weather.fetchWeather(settings.currentCityCode);
    
    // 生成AI建议
    if (weather.hasData) {
      _generateAISuggestion();
    }
  }

  Future<void> _generateAISuggestion() async {
    final weather = context.read<WeatherProvider>();
    final settings = context.read<SettingsProvider>();
    final ai = context.read<AIProvider>();

    if (weather.weatherData != null) {
      await ai.generateSuggestion(
        weatherData: weather.weatherData!,
        city: settings.currentCity,
        cityCode: settings.currentCityCode,
        scene: settings.travelScene,
        style: settings.dressStyle,
        provider: settings.aiProvider,
      );
    }
  }

  Future<void> _onRefresh() async {
    final settings = context.read<SettingsProvider>();
    final weather = context.read<WeatherProvider>();

    await weather.refreshWeather(settings.currentCityCode);
    
    if (weather.error == null) {
      await _generateAISuggestion();
      _refreshController.refreshCompleted();
    } else {
      _refreshController.refreshFailed();
      context.showSnackBar(weather.error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        header: const ClassicHeader(),
        child: _buildBody(),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return const FavoritesScreen();
      case 2:
        return const SettingsScreen();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return CustomScrollView(
      slivers: [
        // 顶部导航栏
        _buildAppBar(),
        
        // 主内容
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              
              // 当前天气卡片
              const CurrentWeatherCard(),
              
              SizedBox(height: 16.h),
              
              // AI一句话总结
              const AISummaryCard(),
              
              SizedBox(height: 16.h),
              
              // 未来7天预报
              const ForecastList(),
              
              SizedBox(height: 16.h),
              
              // AI建议面板
              const AISuggestionPanel(),
              
              SizedBox(height: 16.h),
              
              // 生活指数
              const LifeIndexGrid(),
              
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      title: Consumer2<SettingsProvider, WeatherProvider>(
        builder: (context, settings, weather, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on,
                size: 18.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: 4.w),
              Text(
                settings.currentCity,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 20.sp,
                color: Colors.grey,
              ),
            ],
          );
        },
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: '首页',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          activeIcon: Icon(Icons.favorite),
          label: '收藏',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: '设置',
        ),
      ],
    );
  }
}
