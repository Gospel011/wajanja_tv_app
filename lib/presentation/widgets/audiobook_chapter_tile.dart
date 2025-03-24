import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wajanja/data_layer/models/audiobook/audiobook_chapter.dart';
import 'package:wajanja/presentation/widgets/play_pause_widget.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/mixins.dart';

class AudiobookChapterTile extends StatelessWidget with StatelessThemesMixin {
  const AudiobookChapterTile({
    super.key,
    required this.chapter,
    required this.selected,
    required this.isPlaying,
    this.onPlay,
    this.onTap,
  });
  final AudiobookChapter chapter;
  final bool selected;
  final bool isPlaying;
  final VoidCallback? onTap;
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? colorScheme(context).secondary : null,
        ),
        child: Row(
            spacing: 16.w,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  spacing: 16.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chapter.title),
                    Text(
                      "${(chapter.duration / 60).floor()} min",
                      style: TextStyle(color: colorScheme(context).tertiary),
                    ),
                  ],
                ),
              ),
              PlayPauseWidget(
                onTap: selected ? onPlay : onTap,
                isPlaying: selected && isPlaying,
              ),
            ]),
      ).pOnly(bottom: 16.h),
    );
  }
}
