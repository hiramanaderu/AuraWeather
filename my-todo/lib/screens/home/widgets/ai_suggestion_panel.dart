import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../providers/ai_provider.dart';
import '../../../providers/settings_provider.dart';
import 'ai_suggestion_detail_sheet.dart';

/// AI建议面板
class AISuggestionPanel extends StatelessWidget {
  const AISuggestionPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AIProvider, SettingsProvider>(
      builder: (context, ai, settings, child) {
        if (ai.currentSuggestion == null) {
          return const SizedBox.shrink();
        }

        final travel = ai.currentSuggestion!.travelSuggestion;
        final dress = ai.currentSuggestion!.dressSuggestion;

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
                    'AI 智能建议',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showDetailSheet(context),
                    child: Text(
                      '查看详情',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 12.h),
            
            // 出行建议卡片
            _buildTravelCard(context, travel, settings.travelScene),
            
            SizedBox(height: 12.h),
            
            // 穿搭建议卡片
            _buildDressCard(context, dress, settings.dressStyle),
          ],
        );
      },
    );
  }

  Widget _buildTravelCard(BuildContext context, dynamic travel, String scene) {
    return GestureDetector(
      onTap: () => _showDetailSheet(context, initialTab: 0),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[200]!, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.directions_car,
                    size: 20.sp,
                    color: const Color(0xFF1976D2),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '出行计划 · $scene',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        travel.overallAdvice.truncate(30),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
              ],
            ),
            
            if (travel.essentials.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: travel.essentials.take(4).map<Widget>((item) {
                  return _buildEssentialTag(item);
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDressCard(BuildContext context, dynamic dress, String style) {
    return GestureDetector(
      onTap: () => _showDetailSheet(context, initialTab: 1),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[200]!, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE4EC),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.checkroom,
                    size: 20.sp,
                    color: const Color(0xFFC2185B),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '穿搭建议 · $style',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${dress.top} + ${dress.bottom}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
              ],
            ),
            
            if (dress.accessories.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: dress.accessories.take(4).map<Widget>((item) {
                  return _buildAccessoryTag(item);
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEssentialTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          color: const Color(0xFF1976D2),
        ),
      ),
    );
  }

  Widget _buildAccessoryTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE4EC),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          color: const Color(0xFFC2185B),
        ),
      ),
    );
  }

  void _showDetailSheet(BuildContext context, {int initialTab = 0}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AISuggestionDetailSheet(initialTab: initialTab),
    );
  }
}
