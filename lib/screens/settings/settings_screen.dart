import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../providers/settings_provider.dart';
import '../../config/app_config.dart';

/// 设置页面
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _version = 'v${packageInfo.version}';
      });
    } catch (e) {
      setState(() {
        _version = 'v${AppConfig.appVersion}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            children: [
              // AI设置
              _buildSectionTitle('AI设置'),
              
              // AI提供商选择
              _buildSelectorTile(
                icon: Icons.smart_toy,
                title: 'AI服务',
                subtitle: settings.aiProviderName,
                options: const ['Kimi', '通义千问', 'DeepSeek'],
                onSelected: (value) {
                  String provider;
                  switch (value) {
                    case 'Kimi':
                      provider = 'kimi';
                      break;
                    case '通义千问':
                      provider = 'qwen';
                      break;
                    case 'DeepSeek':
                      provider = 'deepseek';
                      break;
                    default:
                      provider = 'kimi';
                  }
                  settings.setAIProvider(provider);
                },
              ),
              
              const Divider(),
              
              // 场景设置
              _buildSectionTitle('场景与风格'),
              
              // 出行场景
              _buildSelectorTile(
                icon: Icons.directions_car,
                title: '出行场景',
                subtitle: settings.travelScene,
                options: AppConfig.travelScenes,
                onSelected: (value) => settings.setTravelScene(value),
              ),
              
              // 穿搭风格
              _buildSelectorTile(
                icon: Icons.checkroom,
                title: '穿搭风格',
                subtitle: settings.dressStyle,
                options: AppConfig.dressStyles,
                onSelected: (value) => settings.setDressStyle(value),
              ),
              
              const Divider(),
              
              // 单位设置
              _buildSectionTitle('单位设置'),
              
              // 温度单位
              _buildSwitchTile(
                icon: Icons.thermostat,
                title: '温度单位',
                subtitle: settings.useCelsius ? '摄氏度 °C' : '华氏度 °F',
                value: settings.useCelsius,
                onChanged: (_) => settings.toggleTemperatureUnit(),
              ),
              
              const Divider(),
              
              // 数据管理
              _buildSectionTitle('数据管理'),
              
              // 清除缓存
              ListTile(
                leading: const Icon(Icons.cleaning_services_outlined),
                title: const Text('清除缓存'),
                subtitle: const Text('清除天气数据和AI建议缓存'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showClearCacheDialog(context),
              ),
              
              // 重置设置
              ListTile(
                leading: const Icon(Icons.restore),
                title: const Text('恢复默认设置'),
                subtitle: const Text('重置所有设置到默认值'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showResetDialog(context),
              ),
              
              const Divider(),
              
              // 关于
              _buildSectionTitle('关于'),
              
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('关于应用'),
                subtitle: Text('${AppConfig.appName} $_version'),
                onTap: () => _showAboutDialog(context),
              ),
              
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('隐私政策'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: 打开隐私政策
                },
              ),
              
              SizedBox(height: 32.h),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSelectorTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showOptionsBottomSheet(
        title: title,
        options: options,
        selected: subtitle,
        onSelected: onSelected,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required VoidCallback onChanged,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: (_) => onChanged(),
      ),
      onTap: onChanged,
    );
  }

  void _showOptionsBottomSheet({
    required String title,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Divider(height: 1),
            ...options.map((option) => ListTile(
              title: Text(option),
              trailing: option == selected
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              onTap: () {
                onSelected(option);
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除缓存'),
        content: const Text('确定要清除所有缓存数据吗？\n\n这将清除：\n• 天气数据缓存\n• AI建议缓存'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              // TODO: 清除缓存
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('缓存已清除')),
              );
            },
            child: const Text('清除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('恢复默认设置'),
        content: const Text('确定要恢复所有设置到默认值吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final settings = context.read<SettingsProvider>();
              settings.setCurrentCity(AppConfig.defaultCity, AppConfig.defaultCityCode);
              settings.setTravelScene(AppConfig.defaultTravelScene);
              settings.setDressStyle(AppConfig.defaultDressStyle);
              settings.setAIProvider(AppConfig.defaultAIProvider);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已恢复默认设置')),
              );
            },
            child: const Text('恢复', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConfig.appName,
      applicationVersion: _version,
      applicationIcon: Container(
        width: 64.w,
        height: 64.w,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(
          Icons.wb_sunny,
          size: 36.sp,
          color: Colors.white,
        ),
      ),
      applicationLegalese: '© 2024 天气穿搭助手\n\n'
          '一款基于AI的智能天气出行穿搭助手应用，'
          '为您提供精准的天气预报和个性化的出行穿搭建议。',
    );
  }
}
