import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/city_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/weather_provider.dart';
import '../../models/city_model.dart';

/// 收藏城市页面
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的收藏'),
        actions: [
          // 编辑按钮
          Consumer<CityProvider>(
            builder: (context, cityProvider, child) {
              if (cityProvider.favoriteCities.isEmpty) {
                return const SizedBox.shrink();
              }
              return TextButton(
                onPressed: () {
                  _showEditOptions(context);
                },
                child: const Text('管理'),
              );
            },
          ),
        ],
      ),
      body: Consumer<CityProvider>(
        builder: (context, cityProvider, child) {
          if (cityProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cityProvider.favoriteCities.isEmpty) {
            return _buildEmptyState();
          }

          return _buildFavoritesList(cityProvider.favoriteCities);
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          // 跳转到搜索页面
          Navigator.pushNamed(context, '/search');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80.sp,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16.h),
          Text(
            '暂无收藏城市',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '点击右上角搜索添加城市',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(List<City> cities) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: cities.length,
      itemBuilder: (context, index) {
        final city = cities[index];
        return _buildCityCard(context, city);
      },
    );
  }

  Widget _buildCityCard(BuildContext context, City city) {
    return Dismissible(
      key: Key(city.code),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) {
        context.read<CityProvider>().removeFromFavorites(city.code);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已删除 ${city.name}')),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          leading: Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.location_city,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          title: Text(
            city.name,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            city.province,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[500],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 设为当前城市按钮
              if (city.name != context.read<SettingsProvider>().currentCity)
                TextButton(
                  onPressed: () => _setAsCurrentCity(context, city),
                  child: const Text('设为当前'),
                ),
              // 当前城市标记
              if (city.name == context.read<SettingsProvider>().currentCity)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    '当前',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
          onTap: () => _setAsCurrentCity(context, city),
        ),
      ),
    );
  }

  void _setAsCurrentCity(BuildContext context, City city) {
    final settings = context.read<SettingsProvider>();
    final weather = context.read<WeatherProvider>();

    settings.setCurrentCity(city.name, city.code);
    weather.fetchWeather(city.code, forceRefresh: true);

    // 返回首页
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已切换到 ${city.name}')),
    );
  }

  void _showEditOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_sweep),
              title: const Text('清空所有收藏'),
              onTap: () {
                Navigator.pop(context);
                _showClearConfirmation(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sort),
              title: const Text('按名称排序'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 实现排序
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认清空'),
        content: const Text('确定要清空所有收藏的城市吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final cities = context.read<CityProvider>().favoriteCities;
              for (final city in cities) {
                context.read<CityProvider>().removeFromFavorites(city.code);
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已清空所有收藏')),
              );
            },
            child: const Text('确定', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
