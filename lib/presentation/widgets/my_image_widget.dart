import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:wajanja/data_layer/models/helper_models/file_model.dart';
import 'package:wajanja/presentation/widgets/image_place_holder_widget.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';

class MyImageWidget extends StatelessWidget {
  const MyImageWidget({
    super.key,
    this.image,
    this.borderRadius,
    this.onTap,
    this.file,
    this.errorWidget,
    this.placeHolder,
    this.size,
    this.width,
    this.height,
    this.boxfit = BoxFit.cover,
  });

  final double? borderRadius;
  final BoxFit? boxfit;
  final VoidCallback? onTap;

  final double? size;
  final double? width;
  final double? height;

  final String? image;
  final File? file;
  final Widget? placeHolder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 16.0)),
        child: file != null
            ? Image.file(
                io.File(file!.path),
                fit: boxfit,
                width: width ?? size,
                height: height ?? size,
                // frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                //     const ImageLoadingPlaceHolderWidget().shimmer(),
                errorBuilder: (context, error, stacktrace) =>
                    const ImageLoadingPlaceHolderWidget(),
              )
            : CachedNetworkImage(
                imageUrl: image!,
                fit: boxfit,
                width: width ?? size,
                height: height ?? size,
                placeholder: (context, url) =>
                    placeHolder ??
                    const ImageLoadingPlaceHolderWidget().shimmer(),
                errorWidget: (context, url, error) =>
                    errorWidget ?? const ImageLoadingPlaceHolderWidget(),
                fadeInDuration: const Duration(milliseconds: 1),
                fadeInCurve: Curves.linear,
              ),
      ),
    );
  }
}
