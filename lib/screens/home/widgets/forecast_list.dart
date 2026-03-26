import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../providers/weather_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../utils/weather_icons.dart';
import '../../../utils/extensions.dart';

/// 未来7天预报列表
class ForecastList extends StatelessWidget {
  const ForecastList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<WeatherProvider, SettingsProvider>(
      builder: (context, weather, settings, child) {
        if (weather.forecast.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '未来7天',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    weather.getTemperatureRange(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 12.h),
            
            // 横向滑动列表
            SizedBox(
              height: 140.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                itemCount: weather.forecast.length,
                itemBuilder: (context, index) {
                  final forecast = weather.forecast[index];
                  return _buildForecastCard(
                    context,
                    forecast: forecast,
                    settings: settings,
                    isFirst: index == 0,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildForecastCard(
    BuildContext context, {
    required dynamic forecast,
    required SettingsProvider settings,
    required bool isFirst,
  }) {
    // 解析日期
    final date = DateTime.parse(forecast.date);
    final isToday = date.isToday;
    final isTomorrow = date.isTomorrow;
    
    String dayText;
    if (isToday) {
      dayText = '今天';
    } else if (isTomorrow) {
      dayText = '明天';
    } else {
      dayText = date.weekdayText;
    }

    return Container(
      width: 70.w,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isFirst ? Theme.of(context).colorScheme.primary : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isFirst 
              ? Colors.transparent 
              : Colors.grey[200]!,
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 日期
          Text(
            dayText,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isFirst ? Colors.white : Colors.grey[600],
            ),
          ),
          
          SizedBox(height: 2.h),
          
          // 月日
          Text(
            '${date.month}/${date.day}',
            style: TextStyle(
              fontSize: 10.sp,
              color: isFirst ? Colors.white70 : Colors.grey[400],
            ),
          ),
          
          SizedBox(height: 8.h),
          
          // 天气图标
          Icon(
            WeatherIcons.getIcon(forecast.dayWeather),
            size: 28.sp,
            color: isFirst 
                ? Colors.white 
                : WeatherIcons.getColor(forecast.dayWeather),
          ),
          
          SizedBox(height: 6.h),
          
          // 天气文字
          Text(
            forecast.dayWeather,
            style: TextStyle(
              fontSize: 11.sp,
              color: isFirst ? Colors.white : Colors.grey[700],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          SizedBox(height: 6.h),
          
          // 温度
          Text(
            '${settings.formatTemperature(forecast.nightTemp)} / ${settings.formatTemperature(forecast.dayTemp)}',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: isFirst ? Colors.white : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
