import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wajanja/data_layer/models/podcast/podcast.dart';
import 'package:wajanja/handlers/audio_handler.dart';
import 'package:wajanja/presentation/widgets/audioplayer_slider.dart';
import 'package:wajanja/presentation/widgets/labelled_lists.dart';
import 'package:wajanja/presentation/widgets/my_image_widget.dart';
import 'package:wajanja/presentation/widgets/play_pause_widget.dart';
import 'package:wajanja/utils/constants/app_svgs.dart';
import 'package:wajanja/utils/extensions/string_extension.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/mixins.dart';

class PodcastWidget extends ConsumerWidget with StatelessThemesMixin {
  const PodcastWidget({
    super.key,
    required this.podcast,
    this.onPodcastTapped,
    this.isPlaying = false,
    this.onPlayPause,
    this.isExpanded = false,
    this.audioHandler,
    this.mediaItem,
  });

  final Podcast podcast;
  final MyAudioHandler? audioHandler;
  final MediaItem? mediaItem;
  final void Function()? onPodcastTapped;
  final void Function()? onPlayPause;
  final bool isPlaying;
  final bool isExpanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onPodcastTapped,
      child: Container(
        color: Colors.transparent,
        child: Column(
          spacing: 16.h,
          children: [
            Row(
              spacing: 32.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('data')
                PlayPauseWidget(
                  isPlaying: isPlaying,
                  onTap: onPlayPause,
                ),

                Expanded(
                  child: Column(
                    spacing: 32.h,
                    children: [
                      Row(
                        spacing: 24.w,
                        children: [
                          MyImageWidget(
                            image: podcast.coverphoto,
                            size: 64.r,
                            borderRadius: 8.r,
                          ),
                          Expanded(
                            child: Text(
                              podcast.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      if (isExpanded)
                        Column(
                          spacing: 32.h,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              podcast.title,
                              style: textTheme(context).titleMedium,
                            ),
                            AudioPlayerSlider(
                              player: audioHandler != null &&
                                      audioHandler!.currentMediaItem()?.id ==
                                          mediaItem?.id
                                  ? audioHandler!.player
                                  : null,
                              timerStyle: textTheme(context).labelLarge,
                              showStart: false,
                            ),
                            LabelledLists(
                              label: "Speaker(s)",
                              lists: podcast.speakers,
                            ),
                            LabelledLists(
                              label: "Genre",
                              lists: podcast.genre
                                  .map((el) => el.describe.capitalize)
                                  .toList(),
                            ),
                          ],
                        )
                    ],
                  ),
                ),

                SizedBox(
                  height: 64.h,
                  child: Row(
                    spacing: 10.w,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("info"),
                      Transform.rotate(
                        angle: isExpanded ? pi : 0,
                        child: AppSvgs.arrowDown.assetCopy(
                          width: 24.r,
                          height: 24.r,
                          color: colorScheme(context).onSurface,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Divider(
              color: colorScheme(context).secondaryContainer,
            )
          ],
        ),
      ).pSymmetric(horizontal: 0, vertical: 16.h),
    );
  }
}
