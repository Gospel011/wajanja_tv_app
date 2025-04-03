import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wajanja/data_layer/providers/theme_provider/theme_provider.dart';
import 'package:wajanja/presentation/widgets/my_switch_list_tile.dart';
import 'package:wajanja/utils/mixins.dart';

class ThemeControllers extends ConsumerWidget with StatelessThemesMixin {
  const ThemeControllers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [

        // Text("Current Theme MODE: ${themeState.themeMode}"),

        MySwitchListTile(
          value: ref.watch(themeProvider.notifier).isDark(context),
          leading: Text("Use dark theme", style: textTheme(context).titleMedium,),
          onChanged: (_) {
            ref.read(themeProvider.notifier).toggleTheme(context);
          },
        ),
        MySwitchListTile(
          value: themeState.themeMode == ThemeMode.system,
          leading: Text("Use system theme", style: textTheme(context).titleMedium,),
          onChanged: (value) {
            ref.read(themeProvider.notifier).toggleSystemTheme(context);
          },
        ),
      ],
    );
  }
}
