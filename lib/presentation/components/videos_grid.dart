import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/data_layer/models/videos/video.dart';
import 'package:wajanja/presentation/widgets/video_widget.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/helpers/logger.dart';


class VideosGrid extends StatelessWidget {
  const VideosGrid({
    super.key,
    required this.videos,
  });

  final List<Video> videos;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      itemCount: videos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 9 / 16,
          mainAxisSpacing: 10.r,
          crossAxisSpacing: 10.r),
      itemBuilder: (context, index) {
        final video = videos.elementAt(index);
        return VideoWidget(
            video: video,
            onTap: () {
              log.i("GO TO DESCRIPTION FOR VIDEO: $video");

              context.pushNamed(
                AppRoutes.videoDescription.name,
                extra: video,
              );
            });
      },
    );
  }
}
