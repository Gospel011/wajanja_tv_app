import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyLoadingWidget extends StatelessWidget {
  const MyLoadingWidget({super.key, this.color, this.size});
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      color: color ?? Theme.of(context).scaffoldBackgroundColor,
      size: size ?? 24,
    );
  }
}
