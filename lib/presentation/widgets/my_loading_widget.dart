import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wajanja/utils/mixins.dart';

class MyLoadingWidget extends StatelessWidget with StatelessThemesMixin{
  const MyLoadingWidget({super.key, this.color, this.size});
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      color: color ?? colorScheme(context).primary,
      size: size ?? 24,
    );
  }
}
