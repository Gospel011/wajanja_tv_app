import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class IconContainer extends StatelessWidget {
  const IconContainer({
    super.key,
    required this.icon,
    this.size,
    this.backgroundColor,
    this.padding,
    this.onTap,
  });

  final Widget icon;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final double? size;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? EdgeInsets.all(4.r),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ??
              Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: icon,
      ),
    );
  }
}
