import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../providers/ai_provider.dart';

/// AI建议详情底部弹窗
class AISuggestionDetailSheet extends StatefulWidget {
  final int initialTab;

  const AISuggestionDetailSheet({
    super.key,
    this.initialTab = 0,
  });

  @override
  State<AISuggestionDetailSheet> createState() => _AISuggestionDetailSheetState();
}

class _AISuggestionDetailSheetState extends State<AISuggestionDetailSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AIProvider>(
      builder: (context, ai, child) {
        if (ai.currentSuggestion == null) {
          return const SizedBox.shrink();
        }

        final travel = ai.currentSuggestion!.travelSuggestion;
        final dress = ai.currentSuggestion!.dressSuggestion;

        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              // 拖动指示器
              Container(
                margin: EdgeInsets.only(top: 8.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              
              // TabBar
              TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Theme.of(context).colorScheme.primary,
                tabs: const [
                  Tab(text: '出行计划', icon: Icon(Icons.directions_car)),
                  Tab(text: '穿搭建议', icon: Icon(Icons.checkroom)),
                ],
              ),
              
              // Tab内容
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // 出行计划
                    _buildTravelTab(travel),
                    // 穿搭建议
                    _buildDressTab(dress),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTravelTab(dynamic travel) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 最佳时间
          if (travel.bestTime.isNotEmpty)
            _buildSection(
              icon: Icons.access_time,
              title: '最佳出行时间',
              content: travel.bestTime,
              color: const Color(0xFF1976D2),
            ),
          
          // 交通方式
          if (travel.transport.isNotEmpty)
            _buildSection(
              icon: Icons.commute,
              title: '推荐交通方式',
              content: travel.transport,
              color: const Color(0xFF388E3C),
            ),
          
          // 必备物品
          if (travel.essentials.isNotEmpty)
            _buildTagSection(
              icon: Icons.shopping_bag_outlined,
              title: '必备物品',
              items: travel.essentials,
              color: const Color(0xFFF57C00),
            ),
          
          // 注意事项
          if (travel.notices.isNotEmpty)
            _buildListSection(
              icon: Icons.warning_amber_outlined,
              title: '注意事项',
              items: travel.notices,
              color: const Color(0xFFD32F2F),
            ),
          
          // 总体建议
          if (travel.overallAdvice.isNotEmpty)
            _buildSection(
              icon: Icons.lightbulb_outline,
              title: '总体建议',
              content: travel.overallAdvice,
              color: const Color(0xFF7B1FA2),
            ),
          
          // 复制按钮
          _buildCopyButton('出行建议', _formatTravelText(travel)),
        ],
      ),
    );
  }

  Widget _buildDressTab(dynamic dress) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 搭配展示
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE4EC),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildOutfitItem('上衣', dress.top, Icons.checkroom),
                ),
                Icon(Icons.add, color: Colors.grey[400]),
                Expanded(
                  child: _buildOutfitItem('下装', dress.bottom, Icons.accessibility),
                ),
                Icon(Icons.add, color: Colors.grey[400]),
                Expanded(
                  child: _buildOutfitItem('鞋子', dress.shoes, Icons.hiking),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // 配饰
          if (dress.accessories.isNotEmpty)
            _buildTagSection(
              icon: Icons.watch_outlined,
              title: '配饰推荐',
              items: dress.accessories,
              color: const Color(0xFFC2185B),
            ),
          
          // 风格
          if (dress.style.isNotEmpty)
            _buildSection(
              icon: Icons.style,
              title: '整体风格',
              content: dress.style,
              color: const Color(0xFF7B1FA2),
            ),
          
          // 建议
          if (dress.advice.isNotEmpty)
            _buildSection(
              icon: Icons.tips_and_updates_outlined,
              title: '穿搭建议',
              content: dress.advice,
              color: const Color(0xFF1976D2),
            ),
          
          // 复制按钮
          _buildCopyButton('穿搭建议', _formatDressText(dress)),
        ],
      ),
    );
  }

  Widget _buildOutfitItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32.sp, color: const Color(0xFFC2185B)),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 20.sp, color: color),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagSection({
    required IconData icon,
    required String title,
    required List<String> items,
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 20.sp, color: color),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: items.map((item) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: color,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListSection({
    required IconData icon,
    required String title,
    required List<String> items,
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 20.sp, color: color),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8.h),
                ...items.map((item) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 6.sp,
                          color: color,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(fontSize: 13.sp),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyButton(String label, String text) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: text));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label已复制到剪贴板')),
          );
        },
        icon: const Icon(Icons.copy, size: 18),
        label: Text('复制$label'),
      ),
    );
  }

  String _formatTravelText(dynamic travel) {
    return '''出行建议：
最佳时间：${travel.bestTime}
交通方式：${travel.transport}
必备物品：${travel.essentials.join('、')}
注意事项：${travel.notices.join('、')}
总体建议：${travel.overallAdvice}''';}

  String _formatDressText(dynamic dress) {
    return '''穿搭建议：
上衣：${dress.top}
下装：${dress.bottom}
鞋子：${dress.shoes}
配饰：${dress.accessories.join('、')}
风格：${dress.style}
建议：${dress.advice}''';
  }
}
