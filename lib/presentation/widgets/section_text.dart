import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionText extends StatelessWidget {
  const SectionText(
    this.text, {
    super.key,
    this.fontWeight,
    this.textAlign,
    this.fontSize,
    this.height,
    this.style,
  });

  final FontWeight? fontWeight;
  final double? fontSize;
  final double? height;
  final TextAlign? textAlign;
  final TextStyle? style;

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.bodyMedium
          ?.copyWith(
            fontSize: fontSize,
            fontWeight: fontWeight ?? FontWeight.bold,
            height: height,
            color: Theme.of(context).colorScheme.onSurface
          )
          .merge(style),
    );
  }
}
