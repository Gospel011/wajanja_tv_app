import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wajanja/presentation/pages/go_router_config.dart';
import 'package:wajanja/utils/themes/themes.dart';

void main() => runApp(ProviderScope(child: const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final routerConfig = AppRouterConfig();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(440, 956),
      minTextAdapt: true,
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: 'Wajanja Tv',
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(),
                child: child!,
              );
            },
            themeMode: ThemeMode.system,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            routerConfig: routerConfig.router,
          );
        },
      ),
    );
  }
}
