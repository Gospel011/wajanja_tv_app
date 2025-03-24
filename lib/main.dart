import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wajanja/data_layer/db/user_db.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/data_layer/providers/theme_provider/theme_provider.dart';
import 'package:wajanja/data_layer/providers/theme_provider/theme_state.dart';
import 'package:wajanja/firebase_options.dart';
import 'package:wajanja/presentation/pages/go_router_config.dart';
import 'package:wajanja/utils/themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  // Hive.registerAdapter(ThemeStateAdapter());

  await Hive.openBox<String>('themes');

  await UserDb.instance.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  static final routerConfig = AppRouterConfig();

  late final GoRouter router;

  @override
  void initState() {
    super.initState();
    router = routerConfig.createRouter(ref);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(440, 956),
      minTextAdapt: true,
      child: Builder(
        builder: (context) {
          final theme = ref.watch(themeProvider);
          return MaterialApp.router(
            title: 'Wajanja Tv',
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(),
                child: child!,
              );
            },
            themeMode: theme.themeMode,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
