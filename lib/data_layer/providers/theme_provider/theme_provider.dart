import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wajanja/data_layer/providers/theme_provider/theme_state.dart';

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(ThemeState(themeMode: ThemeMode.system));

  void toggleTheme(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    state = state.copyWith(
      themeMode:
          brightness == Brightness.light ? ThemeMode.dark : ThemeMode.light,
    );
  }

  void toggleSystemTheme(context) {
    final brightness = Theme.of(context).brightness;

    state = state.copyWith(
      themeMode:
          state.themeMode == ThemeMode.system
              ? (brightness == Brightness.dark
                  ? ThemeMode.dark
                  : ThemeMode.light)
              : ThemeMode.system,
    );
  }

  bool isDark(BuildContext context) {
    return state.themeMode == ThemeMode.dark ||
        Theme.of(context).brightness == Brightness.dark;
  }

  bool isUsingSystemTheme() {
    return state.themeMode == ThemeMode.system;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
