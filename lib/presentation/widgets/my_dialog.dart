import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final String? title;
  final dynamic content;
  final List<Widget>? actions;
  const MyDialog({super.key, this.title, required this.content, this.actions});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      // backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      title:
          title != null
              ? Center(
                child: Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              : null,
      content:
          content is! String
              ? content
              : Text(
                content as String,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
      actions: actions,
    );
  }
}
