import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wajanja/utils/mixins.dart';


class PlayPauseWidget extends StatelessWidget with StatelessThemesMixin {
  const PlayPauseWidget({
    super.key,
    required this.isPlaying,
    this.onTap,
  });

  final bool isPlaying;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
            color: isPlaying
                ? colorScheme(context).primary
                : colorScheme(context).onSurface,
            shape: BoxShape.circle),
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          color: colorScheme(context).onPrimary,
          size: 40.r,
        ),
      ),
    );
  }
}
