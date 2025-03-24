import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wajanja/data_layer/providers/theme_provider/theme_state.dart';

class ThemeNotifier extends Notifier<ThemeState> {
  // ThemeNotifier() : super(ThemeState(themeMode: ThemeMode.system));

  late final Box<String> themeBox;

  @override
  ThemeState build() {
    themeBox = Hive.box<String>("themes");
    final themeMap = themeBox.get('theme');

    return themeMap != null
        ? ThemeState.fromJson(themeMap)
        : ThemeState(themeMode: ThemeMode.system);
  }

  void toggleTheme(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    state = state.copyWith(
      themeMode:
          brightness == Brightness.light ? ThemeMode.dark : ThemeMode.light,
    );

    themeBox.put('theme', state.toJson());
  }

  void toggleSystemTheme(context) {
    final brightness = Theme.of(context).brightness;

    state = state.copyWith(
      themeMode: state.themeMode == ThemeMode.system
          ? (brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light)
          : ThemeMode.system,
    );

    themeBox.put('theme', state.toJson());
  }

  bool isDark(BuildContext context) {
    return state.themeMode == ThemeMode.dark ||
        Theme.of(context).brightness == Brightness.dark;
  }

  bool isUsingSystemTheme() {
    return state.themeMode == ThemeMode.system;
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(() {
  return ThemeNotifier();
});
