import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wajanja/presentation/widgets/section_text.dart';
import 'package:wajanja/utils/constants/app_colors.dart';
import 'package:wajanja/utils/constants/enums.dart';

class MyTextFormField extends StatelessWidget {
  /// This is used to access the user's input
  final TextEditingController controller;

  /// A function that accepts a nullable string. Used to validate the input
  /// before further action is taked
  final String? Function(String?) validator;

  /// This tells the user what to input in the TextFormField
  final String? hintText;

  /// This is the [widget] that would be shown at the far right of the
  /// TextFormField
  final Widget? suffixIcon;

  /// This is the function that is executed when the [suffixIcon] is pressed.
  final void Function()? suffixOnpressed;

  /// This specifies whether to hide the text or not.
  final bool obscureText;

  /// This specifies whether the user is allowed to input text in the
  /// TextFormField.
  final bool? enabled;

  /// This specifies whether the textfield is editable or not. It stil
  /// uses the enabled text theme, unlike when enabled is set to false.
  final bool? readOnly;

  /// This specifies which type of keyboard should be shown to the user
  final TextInputType? keyboardType;

  /// This controls whether the textform field should be in focus or not
  final FocusNode? focusNode;

  /// What happens when the textform field value is changed
  final void Function(String)? onChanged;

  /// The textfield type
  final TextFieldType? textFieldType;

  /// The action to execute when this textfield is tapped
  final void Function()? onTap;

  /// This filters the users input and accepts only the valid ones.
  final List<TextInputFormatter>? inputFormatters;

  /// The maximum lines the text in this can cover
  final int? maxLines;

  /// The spacing between the edges and the content of this
  final EdgeInsetsGeometry? contentPadding;

  /// An additional descriptive text that would be displayed above the formfield.
  final String? sectionText;

  /// An additional descriptive text that would be displayed above the formfield.
  final FontWeight? sectionTextFontWeight;

  /// The padding for the entire widget
  final EdgeInsetsGeometry? padding;

  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final int? minLines;
  final String? prefixText;
  final void Function(String value)? onFieldSubmitted;
  final TextInputAction? textInputAction;

  const MyTextFormField(
      {super.key,
      this.hintText,
      this.onTap,
      required this.controller,
      required this.validator,
      this.prefixText,
      this.minLines,
      this.padding,
      this.sectionText,
      this.sectionTextFontWeight,
      this.onFieldSubmitted,
      this.maxLines,
      this.contentPadding,
      this.suffixIcon,
      this.suffixOnpressed,
      this.obscureText = false,
      this.readOnly,
      this.enabled,
      this.keyboardType,
      this.inputFormatters,
      this.focusNode,
      this.onChanged,
      this.enabledBorder,
      this.focusedBorder,
      this.errorBorder,
      this.textFieldType,
      this.textInputAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sectionText != null)
            SectionText(sectionText!, fontWeight: sectionTextFontWeight),
          if (sectionText != null) const SizedBox(height: 8),
          TextFormField(
            obscureText: obscureText,
            enabled: enabled,
            readOnly: readOnly ?? false,
            maxLines: obscureText == false ? (maxLines ?? 1) : 1,
            minLines: minLines,
            onTap: onTap,
            focusNode: focusNode,
            onChanged: onChanged,
            controller: controller,
            validator: validator,
            textInputAction: textInputAction,
            onFieldSubmitted: onFieldSubmitted,
            style: Theme.of(context).inputDecorationTheme.hintStyle?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.bgLight
                      : AppColors.gray700,
                ),
            cursorColor: Theme.of(context).textTheme.bodyMedium?.color,
            textAlign: textFieldType == TextFieldType.otp
                ? TextAlign.center
                : TextAlign.start,
            keyboardType: textFieldType == TextFieldType.otp
                ? TextInputType.number
                : (hintText?.toLowerCase().contains('email') == true) ||
                        (sectionText?.toLowerCase().contains('email') == true)
                    ? TextInputType.emailAddress
                    : keyboardType,
            cursorWidth: 1.0,
            decoration: InputDecoration(
              contentPadding: textFieldType == TextFieldType.otp
                  ? const EdgeInsets.symmetric(horizontal: 8)
                  : contentPadding,
              hintText: hintText,
              prefixText: prefixText,
              suffixIcon: suffixIcon != null
                  ? IconButton(
                      onPressed: suffixOnpressed,
                      icon: suffixIcon!,
                    )
                  : null,
            ),
            inputFormatters: textFieldType == TextFieldType.otp
                ? [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ]
                : inputFormatters,
          ),
        ],
      ),
    );
  }
}
