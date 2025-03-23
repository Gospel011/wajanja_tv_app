import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wajanja/presentation/pages/videos/video_description.dart';
import 'package:wajanja/utils/constants/app_svgs.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/mixins.dart';

class Engagementbuttons extends StatefulWidget {
  const Engagementbuttons(
      {super.key,
      this.liked,
      this.disliked,
      this.onLikePressed,
      this.onDislikePressed});
  final bool? liked;
  final bool? disliked;
  final VoidCallback? onLikePressed;
  final VoidCallback? onDislikePressed;

  @override
  State<Engagementbuttons> createState() => _EngagementbuttonsState();
}

class _EngagementbuttonsState extends State<Engagementbuttons>
    with ThemesMixin {
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20.w,
      children: [
        IconContainer(
          icon: AppSvgs.like.assetCopy(
            color: widget.liked == true ? colorScheme.surface : null,
          ),
          backgroundColor: widget.liked == true
              ? colorScheme.primary
              : colorScheme.secondaryContainer,
          onTap: widget.onLikePressed,
        ),
        IconContainer(
          icon: AppSvgs.dislike.assetCopy(
            color: widget.disliked == true ? colorScheme.surface : null,
          ),
          backgroundColor: widget.disliked == true
              ? colorScheme.primary
              : colorScheme.secondaryContainer,
          onTap: widget.onDislikePressed,
        ),
        IconContainer(
          onTap: () {},
          icon: AppSvgs.share,
        ),
      ],
    );
  }
}
