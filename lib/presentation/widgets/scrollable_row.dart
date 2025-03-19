import 'package:flutter/material.dart';



class ScrollableRow extends StatelessWidget {
  const ScrollableRow({
    super.key,
    required this.children,
    this.spacing = 0.0,
  });

  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: spacing,
        children: children,
      ),
    );
  }
}
