import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';

class SpacedColumn extends StatelessWidget {
  const SpacedColumn({
    super.key,
    required this.children,
    this.gap,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });



  final double? gap;
  final List<Widget> children;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      children: List<Widget>.generate(children.length, (index) {
        return children
            .elementAt(index)
            .pOnly(bottom: index != children.length - 1 ? gap ?? 16.h : 0);
      }),
    );
  }
}
