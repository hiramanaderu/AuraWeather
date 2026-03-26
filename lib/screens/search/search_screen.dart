import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/city_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/weather_provider.dart';
import '../../models/city_model.dart';
import '../../utils/extensions.dart';

/// 城市搜索页面
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 加载搜索历史
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CityProvider>().loadSearchHistory();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    if (value.isEmpty) return;
    context.read<CityProvider>().searchCity(value);
  }

  void _onCitySelected(City city) async {
    final cityProvider = context.read<CityProvider>();
    final settings = context.read<SettingsProvider>();
    final weather = context.read<WeatherProvider>();

    // 添加到搜索历史
    await cityProvider.addToHistory(city.code, city.name);
    
    // 设置当前城市
    settings.setCurrentCity(city.name, city.code);
    
    // 加载新城市天气
    await weather.fetchWeather(city.code, forceRefresh: true);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          autofocus: true,
          decoration: InputDecoration(
            hintText: '搜索城市（中文/拼音）',
            hintStyle: TextStyle(
              fontSize: 15.sp,
              color: Colors.grey[400],
            ),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      context.read<CityProvider>().clearSearchResults();
                      setState(() {});
                    },
                  )
                : null,
          ),
          onChanged: (value) => setState(() {}),
          onSubmitted: _onSearch,
        ),
        actions: [
          TextButton(
            onPressed: () => _onSearch(_searchController.text),
            child: const Text('搜索'),
          ),
        ],
      ),
      body: Consumer<CityProvider>(
        builder: (context, cityProvider, child) {
          if (cityProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 显示搜索结果
          if (cityProvider.searchResults.isNotEmpty) {
            return _buildSearchResults(cityProvider.searchResults);
          }

          // 显示搜索历史
          return _buildHistory(cityProvider.searchHistory);
        },
      ),
    );
  }

  Widget _buildSearchResults(List<City> cities) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: cities.length,
      itemBuilder: (context, index) {
        final city = cities[index];
        return _buildCityTile(city);
      },
    );
  }

  Widget _buildHistory(List<SearchHistory> history) {
    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64.sp,
              color: Colors.grey[300],
            ),
            SizedBox(height: 16.h),
            Text(
              '搜索城市查看天气',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题和清空按钮
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '搜索历史',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<CityProvider>().clearHistory();
                },
                child: Text(
                  '清空',
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
            ],
          ),
        ),
        
        // 历史列表
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return ListTile(
                leading: Icon(
                  Icons.history,
                  size: 20.sp,
                  color: Colors.grey[400],
                ),
                title: Text(item.cityName),
                subtitle: Text(
                  item.searchTime.friendlyTime,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey[400],
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  size: 20.sp,
                  color: Colors.grey[400],
                ),
                onTap: () {
                  // 从历史记录加载
                  final settings = context.read<SettingsProvider>();
                  final weather = context.read<WeatherProvider>();
                  settings.setCurrentCity(item.cityName, item.cityCode);
                  weather.fetchWeather(item.cityCode, forceRefresh: true);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCityTile(City city) {
    return ListTile(
      leading: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          Icons.location_city,
          size: 20.sp,
          color: Colors.grey[500],
        ),
      ),
      title: Text(city.displayName),
      subtitle: Text(
        city.fullName,
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.grey[500],
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 收藏按钮
          IconButton(
            icon: Icon(
              city.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: city.isFavorite ? Colors.red : Colors.grey[400],
            ),
            onPressed: () {
              context.read<CityProvider>().toggleFavorite(city);
            },
          ),
          // 选择按钮
          Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
          ),
        ],
      ),
      onTap: () => _onCitySelected(city),
    );
  }
}
