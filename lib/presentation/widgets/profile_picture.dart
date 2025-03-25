import 'dart:io' as io;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wajanja/data_layer/models/helper_models/file_model.dart';
// import 'package:wajanja/data_layer/models/helper_models/file_model.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/utils/mixins.dart';

class ProfilePicture extends StatelessWidget with StatelessThemesMixin {
  const ProfilePicture({
    super.key,
    required this.user,
    this.size,
    this.onTap,
    this.file,
  });

  final User? user;
  final double? size;
  final VoidCallback? onTap;
  final File? file;
  // File

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      // final user = ref.read(authNotifierProvider).user!;
      return GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular((size ?? 50.r) * 3),
          child: file != null
              ? Image.file(
                  io.File(file!.path),
                  width: (size ?? 50.r),
                  height: (size ?? 50.r),
                )
              : user?.photoURL == null
                  ? buildErrorWidget(context)
                  : CachedNetworkImage(
                      imageUrl: user?.photoURL ?? '',
                      fit: BoxFit.cover,
                      width: size ?? 50.r,
                      errorWidget: (context, url, error) {
                        return buildErrorWidget(context);
                      },
                    ),
        ),
      );
    });
  }

  Container buildErrorWidget(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: size ?? 50.r,
      height: size ?? 50.r,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).colorScheme.onSurface)),
      child: Text(
        user?.initials ?? '',
        style: (size ?? 50.r) < 20.r
            ? textTheme(context).bodySmall
            : (size ?? 50.r) < 30
                ? textTheme(context).labelLarge
                : textTheme(context).titleLarge,
      ),
    );
  }
}
