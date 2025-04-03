import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wajanja/data_layer/providers/theme_provider/theme_provider.dart';
import 'package:wajanja/utils/mixins.dart';

class MySwitchListTile extends ConsumerWidget with StatelessThemesMixin {
  const MySwitchListTile({
    super.key,
    required this.leading,
    required this.value,
    required this.onChanged,
  });
  final Widget leading;
  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      titleAlignment: ListTileTitleAlignment.center,
      leading: leading,//,Text("Use dark theme", style: textTheme(context).titleMedium),
      onTap: () {
        // ref.read(themeProvider.notifier).toggleTheme(context);
        onChanged(!value);
      },
      trailing: CupertinoSwitch(
        value: value,// ref.watch(themeProvider.notifier).isDark(context),
        onChanged: onChanged,
        // onChanged: (_) {
        //   ref.read(themeProvider.notifier).toggleTheme(context);
        // },
      ),
    );
  }
}
