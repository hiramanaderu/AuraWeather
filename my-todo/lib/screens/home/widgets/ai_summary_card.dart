import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../providers/ai_provider.dart';

/// AI天气总结卡片
class AISummaryCard extends StatelessWidget {
  const AISummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AIProvider>(
      builder: (context, ai, child) {
        if (ai.isLoading && ai.currentSuggestion == null) {
          return _buildSkeleton();
        }

        if (ai.currentSuggestion == null) {
          return const SizedBox.shrink();
        }

        final summary = ai.currentSuggestion!.weatherSummary;
        final hasAlerts = summary.alerts.isNotEmpty;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: hasAlerts ? const Color(0xFFFFF3E0) : const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: hasAlerts ? const Color(0xFFFFCC80) : const Color(0xFFA5D6A7),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题行
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 16.sp,
                    color: hasAlerts ? const Color(0xFFEF6C00) : const Color(0xFF2E7D32),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'AI 天气总结',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: hasAlerts ? const Color(0xFFEF6C00) : const Color(0xFF2E7D32),
                    ),
                  ),
                  if (hasAlerts) ...[
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '预警',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              
              SizedBox(height: 10.h),
              
              // 总结文字
              Text(
                summary.summary,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.5,
                ),
              ),
              
              // 预警信息
              if (summary.alerts.isNotEmpty) ...[
                SizedBox(height: 8.h),
                ...summary.alerts.map((alert) => Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 14.sp,
                        color: const Color(0xFFE53935),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          alert,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFFE53935),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
              
              // 趋势信息
              if (summary.trend.isNotEmpty || summary.rainForecast.isNotEmpty) ...[
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 12.w,
                  children: [
                    if (summary.trend.isNotEmpty)
                      _buildTag(Icons.trending_up, summary.trend),
                    if (summary.rainForecast.isNotEmpty)
                      _buildTag(Icons.water_drop, summary.rainForecast),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildTag(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: Colors.grey[600]),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
