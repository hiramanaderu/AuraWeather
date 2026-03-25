import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../providers/weather_provider.dart';

/// 生活指数网格
class LifeIndexGrid extends StatelessWidget {
  const LifeIndexGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weather, child) {
        if (weather.lifeIndex == null) {
          return const SizedBox.shrink();
        }

        final index = weather.lifeIndex!;

        // 构建生活指数列表
        final items = [
          _IndexItem(
            icon: Icons.wb_sunny_outlined,
            label: '紫外线',
            value: index.uv.isNotEmpty ? '${index.uv}级' : '--',
            color: const Color(0xFFFFA726),
          ),
          _IndexItem(
            icon: Icons.air,
            label: '空气质量',
            value: index.airQuality.isNotEmpty ? index.airQuality : '良',
            color: const Color(0xFF66BB6A),
          ),
          _IndexItem(
            icon: Icons.checkroom,
            label: '穿衣',
            value: index.dress.isNotEmpty ? index.dress : '舒适',
            color: const Color(0xFF42A5F5),
          ),
          _IndexItem(
            icon: Icons.local_car_wash_outlined,
            label: '洗车',
            value: index.carWash.isNotEmpty ? index.carWash : '适宜',
            color: const Color(0xFF26C6DA),
          ),
          _IndexItem(
            icon: Icons.sports_basketball_outlined,
            label: '运动',
            value: index.sport.isNotEmpty ? index.sport : '适宜',
            color: const Color(0xFFAB47BC),
          ),
          _IndexItem(
            icon: Icons.local_hospital_outlined,
            label: '感冒',
            value: index.cold.isNotEmpty ? index.cold : '少发',
            color: const Color(0xFFEF5350),
          ),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                '生活指数',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            SizedBox(height: 12.h),
            
            // 网格
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.h,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _buildIndexCard(items[index]);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIndexCard(_IndexItem item) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!, width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item.icon,
            size: 24.sp,
            color: item.color,
          ),
          SizedBox(height: 6.h),
          Text(
            item.value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: item.color,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

class _IndexItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  _IndexItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}
