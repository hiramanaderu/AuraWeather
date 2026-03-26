import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../providers/weather_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../utils/weather_icons.dart';

/// 当前天气卡片
class CurrentWeatherCard extends StatelessWidget {
  const CurrentWeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<WeatherProvider, SettingsProvider>(
      builder: (context, weather, settings, child) {
        if (weather.isLoading && weather.weatherData == null) {
          return _buildSkeleton();
        }

        if (weather.error != null && weather.weatherData == null) {
          return _buildError(weather.error!);
        }

        final current = weather.currentWeather;
        if (current == null) {
          return _buildSkeleton();
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: WeatherIcons.getGradient(current.weather),
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // 天气图标和主要信息
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    WeatherIcons.getIcon(current.weather),
                    size: 64.sp,
                    color: WeatherIcons.getColor(current.weather),
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        settings.formatTemperature(current.temperature),
                        style: TextStyle(
                          fontSize: 56.sp,
                          fontWeight: FontWeight.w300,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        current.weather,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              SizedBox(height: 20.h),
              
              // 详细信息
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildWeatherItem(
                      context,
                      icon: Icons.water_drop_outlined,
                      label: '湿度',
                      value: '${current.humidity}%',
                    ),
                    _buildWeatherItem(
                      context,
                      icon: Icons.air,
                      label: '风力',
                      value: current.windPower,
                    ),
                    _buildWeatherItem(
                      context,
                      icon: Icons.visibility_outlined,
                      label: '能见度',
                      value: '${current.visibility}km',
                    ),
                    _buildWeatherItem(
                      context,
                      icon: Icons.speed_outlined,
                      label: '气压',
                      value: '${current.pressure}hPa',
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 12.h),
              
              // 更新时间
              Text(
                '更新于 ${weather.lastUpdateTime?.toString().substring(11, 16) ?? '--:--'}',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeatherItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
    );
  }

  Widget _buildError(String error) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off,
            size: 48.sp,
            color: Colors.grey,
          ),
          SizedBox(height: 12.h),
          Text(
            error,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
