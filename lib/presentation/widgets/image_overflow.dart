import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wajanja/utils/mixins.dart';

class ImageOverflow extends StatelessWidget with StatelessThemesMixin {
  const ImageOverflow(
      {super.key, required this.overflow, this.onTap, this.width, this.height});

  final int overflow;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        // color: colorScheme.tertiaryFixed,
        width: width,
        height: height,
        color: isDarkTheme(context)
            ? colorScheme(context).surfaceTint.withValues(alpha: 0.1)
            : colorScheme(context).tertiaryFixed.withValues(alpha: 0.1),
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
              // color: colorScheme.surfaceTint.withValues(alpha: 0.1),
              shape: BoxShape.circle),
          child: Text(
            "+$overflow",
            style: textTheme(context)
                .titleMedium
                ?.copyWith(color: colorScheme(context).onSurface),
          ),
        ),
      ),
    );
  }
}
