import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wajanja/presentation/widgets/my_loading_widget.dart';

class MyElevatedButton extends StatelessWidget {
  final String text;
  final bool? loading;
  final MainAxisSize mainAxisSize;
  final void Function()? onPressed;
  final IconData? icon;
  final dynamic leadingIcon;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final BorderRadiusGeometry? borderRadius;

  const MyElevatedButton({
    super.key,
    this.onPressed,
    this.mainAxisSize = MainAxisSize.max,
    this.borderRadius,
    required this.text,
    this.icon,
    this.textStyle,
    this.loading,
    this.backgroundColor,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.h,
      child: ElevatedButton(
        // style: ButtonStyle(
        //   backgroundColor: WidgetStatePropertyAll(backgroundColor),
        // ),
        onPressed: () {
          if (onPressed == null) return;
          loading == true ? null : onPressed!();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: mainAxisSize,
          children: [
            if (leadingIcon != null)
              leadingIcon is Widget
                  ? leadingIcon
                  : SvgPicture.asset(leadingIcon!)
            else
              const SizedBox(width: 0),
            if (leadingIcon != null)
              const SizedBox(width: 10)
            else
              const SizedBox(width: 0),
            loading != true
                ? Text(text, style: textStyle)
                : const Center(
                  // height: 24,
                  // width: 24,
                  child: MyLoadingWidget(),
                ),
            if (icon != null) Icon(icon) else const SizedBox(width: 0),
          ],
        ),
      ),
    );
  }
}
