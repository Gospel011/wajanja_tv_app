import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class MyPinInput extends StatelessWidget {
  const MyPinInput({
    super.key,
    required this.controller,
    this.size,
    this.length = 4,
    this.obscureText = true,
    this.hintText,
    this.onCompleted,
    this.onChanged,
  });
  final double? size;
  final int length;
  final bool obscureText;
  final String? hintText;
  final void Function(String)? onCompleted;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final inputDecorationTheme = Theme.of(context).inputDecorationTheme;

    final defaultPinTheme = PinTheme(
      width: size ?? 70.r,
      height: size ?? 70.r,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: inputDecorationTheme.fillColor,
        // border: Border.all(color: AppColors.midnightTeal.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(16.r),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      color: Theme.of(context).colorScheme.secondaryContainer,
      // border: Border.all(color: AppColors.midnightTeal.withOpacity(0.5)),
      // borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        // color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Pinput(
      controller: controller,
      onChanged: onChanged,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      length: length,
      obscureText: obscureText,
      preFilledWidget: Text(hintText ?? ''),
      onCompleted: onCompleted,
      separatorBuilder: (_) {
        // final screenWidth = MediaQuery.sizeOf(context).width;

        // final separatorWidth =
        //     (screenWidth -
        //         2 * AppConstants.defaultPadding -
        //         (size ?? 70.r) * length) /
        //     (length - 1);

        // print("_______________________");
        // print("screen width: $screenWidth");
        // print("default padding: ${AppConstants.defaultPadding}");
        // print("size: ${size ?? 70.r}");
        // print("length: $length");
        // print("Separator width: $separatorWidth");

        return SizedBox(
          // width: separatorWidth < 0 ? 8 : separatorWidth,
          width: 10.w,
        );
      },
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      submittedPinTheme: submittedPinTheme,
      pinputAutovalidateMode: PinputAutovalidateMode.disabled,
      showCursor: true,
    );
  }
}
