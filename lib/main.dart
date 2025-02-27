import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wajanja/data_layer/db/user_db.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/firebase_options.dart';
import 'package:wajanja/presentation/pages/go_router_config.dart';
import 'package:wajanja/utils/themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());

  await UserDb.instance.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  static final routerConfig = AppRouterConfig();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            routerConfig: routerConfig.createRouter(ref),
          );
        },
      ),
    );
  }
}
