import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/data_layer/models/videos/video.dart';
import 'package:wajanja/presentation/widgets/scrollable_row.dart';
import 'package:wajanja/presentation/widgets/video_widget.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/helpers/logger.dart';

class VideoRow extends StatelessWidget {
  const VideoRow({
    super.key,
    required this.videos,
    this.onVideoTap,
    this.title,
    this.maxLength,
  });

  final List<Video> videos;
  final int? maxLength;
  final String? title;
  final void Function(Video video)? onVideoTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: TextStyle(fontWeight: FontWeight.bold),
          ).pOnly(left: 16.w),
        ScrollableRow(
          spacing: 16.w,
          children: [
            SizedBox.shrink(),
            ...List<Widget>.generate(
                maxLength != null
                    ? (videos.length > maxLength! ? maxLength! : videos.length)
                    : videos.length, (index) {
              final video = videos.elementAt(index);

              return VideoWidget(
                video: video,
                height: 300.h,
                onTap: () {
                  if (onVideoTap != null) {
                    log.f("VIDEO: $video");
                    onVideoTap!(video);
                    return;
                  }
                  context.goNamed(
                    AppRoutes.videoDescription.name,
                    extra: video,
                  );
                },
              );
            }),
            SizedBox.shrink()
          ],
        ),
      ],
    );
  }
}
