import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wajanja/utils/mixins.dart';



class LabelledLists extends StatelessWidget with StatelessThemesMixin {
  const LabelledLists({
    super.key,
    required this.label,
    required this.lists,
  });

  final String label;
  final List<String> lists;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colorScheme(context).outline,
          ),
        ),
        Text("${lists.join(', ')}.")
      ],
    );
  }
}
