import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 日期时间扩展
extension DateTimeExtension on DateTime {
  /// 格式化日期
  String format([String pattern = 'yyyy-MM-dd']) {
    return DateFormat(pattern).format(this);
  }

  /// 获取星期几（中文）
  String get weekdayText {
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return weekdays[weekday - 1];
  }

  /// 获取友好时间
  String get friendlyTime {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inDays > 0) {
      return diff.inDays == 1 ? '昨天' : format('MM-dd');
    }
    if (diff.inHours > 0) return '${diff.inHours}小时前';
    if (diff.inMinutes > 0) return '${diff.inMinutes}分钟前';
    return '刚刚';
  }

  /// 是否是今天
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// 是否是明天
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }
}

/// 字符串扩展
extension StringExtension on String {
  /// 截断字符串
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return substring(0, maxLength - suffix.length) + suffix;
  }

  /// 移除所有空白字符
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// 首字母大写
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// 转换为int，失败返回null
  int? get toIntOrNull => int.tryParse(this);

  /// 转换为double，失败返回null
  double? get toDoubleOrNull => double.tryParse(this);
}

/// 数字扩展
extension NumExtension on num {
  /// 转换为温度字符串
  String toTemperatureString({bool showUnit = true}) {
    final temp = round();
    return showUnit ? '$temp°C' : '$temp';
  }

  /// 转换为百分比
  String toPercent({int decimals = 0}) {
    final format = NumberFormat.percentPattern()
      ..minimumFractionDigits = decimals
      ..maximumFractionDigits = decimals;
    return format.format(this);
  }
}

/// 列表扩展
extension ListExtension<T> on List<T> {
  /// 安全获取元素
  T? getOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// 分批处理
  List<List<T>> chunked(int size) {
    final result = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      result.add(sublist(i, i + size > length ? length : i + size));
    }
    return result;
  }
}

/// 上下文扩展
extension BuildContextExtension on BuildContext {
  /// 屏幕宽度
  double get screenWidth => MediaQuery.of(this).size.width;

  /// 屏幕高度
  double get screenHeight => MediaQuery.of(this).size.height;

  /// 安全区域顶部内边距
  double get safeTop => MediaQuery.of(this).padding.top;

  /// 安全区域底部内边距
  double get safeBottom => MediaQuery.of(this).padding.bottom;

  /// 是否为深色模式
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// 显示SnackBar
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// 显示底部弹窗
  Future<T?> showBottomSheet<T>(Widget child, {bool isScrollControlled = false}) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (context) => child,
    );
  }

  /// 显示对话框
  Future<T?> showDialog<T>(Widget child, {bool barrierDismissible = true}) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
    );
  }

  /// 隐藏键盘
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }
}
