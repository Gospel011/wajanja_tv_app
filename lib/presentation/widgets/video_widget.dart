import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wajanja/data_layer/models/videos/video.dart';
import 'package:wajanja/utils/constants/app_colors.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';

class VideoWidget extends StatelessWidget {
  const VideoWidget({super.key, required this.video, this.height, this.width, this.onTap});

  final Video video;
  final double? height;
  final double? width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height,
        width: width,
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            // decoration: BoxDecoration(
            //   color: Theme.of(context).colorScheme.surfaceTint,
            //   borderRadius: BorderRadius.circular(16.r),
            // ),
            child: CachedNetworkImage(
              imageUrl: video.coverPhotoPortrait,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Container(
                  color: AppColors.smokeyGrayLight,
                ).shimmer();
              },
              errorWidget: (context, url, error) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: AppColors.smokeyGrayLight,
                  ),
                  child: Text(
                    video.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.deepSlateDark,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                );
              },
            ),
            // height: 50.h,
          ),
        ),
      ),
    );
  }
}
