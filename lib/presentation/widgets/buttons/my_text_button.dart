import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.style,
  });

  final VoidCallback onPressed;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      
      style: ButtonStyle(
        foregroundColor:
            style != null ? WidgetStatePropertyAll(style?.color) : null,
        textStyle: WidgetStatePropertyAll(
          Theme.of(context).textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold)
              .merge(style),
        ),
      ),
      child: Text(text),
    );
  }
}
