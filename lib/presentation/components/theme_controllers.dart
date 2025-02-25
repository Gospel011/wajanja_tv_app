import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wajanja/data_layer/providers/theme_provider/theme_provider.dart';



class ThemeControllers extends StatelessWidget {
  const ThemeControllers({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            SwitchListTile.adaptive(
              value: ref.watch(themeProvider.notifier).isDark(context),
              title: Text("Use dark theme"),
              onChanged: (_) {
                ref.read(themeProvider.notifier).toggleTheme(context);
              },
            ),

            SwitchListTile.adaptive(
              value: ref.watch(themeProvider.notifier).isUsingSystemTheme(),
              title: Text("Use system theme"),
              onChanged: (value) {
                ref.read(themeProvider.notifier).toggleSystemTheme(context);
              },
            ),
          ],
        );
      },
    );
  }
}
