import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'config/app_config.dart';
import 'config/theme_config.dart';
import 'providers/weather_provider.dart';
import 'providers/city_provider.dart';
import 'providers/ai_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/home/home_screen.dart';
import 'services/api_service.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化服务
  ApiService.instance.initialize();
  await DatabaseService.instance.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SettingsProvider()),
            ChangeNotifierProvider(create: (_) => CityProvider()),
            ChangeNotifierProvider(create: (_) => WeatherProvider()),
            ChangeNotifierProvider(create: (_) => AIProvider()),
          ],
          child: RefreshConfiguration(
            headerBuilder: () => const ClassicHeader(),
            footerBuilder: () => const ClassicFooter(),
            hideFooterWhenNotFull: true,
            child: MaterialApp(
              title: AppConfig.appName,
              debugShowCheckedModeBanner: false,
              theme: ThemeConfig.lightTheme,
              darkTheme: ThemeConfig.darkTheme,
              themeMode: ThemeMode.light,
              home: const HomeScreen(),
            ),
          ),
        );
      },
    );
  }
}
