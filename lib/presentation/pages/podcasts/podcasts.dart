import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wajanja/data_layer/models/podcast/podcast.dart';
import 'package:wajanja/data_layer/providers/audio_player_provider/audio_player_provider.dart';
import 'package:wajanja/my_tests/sample_podcasts.dart';
import 'package:wajanja/presentation/widgets/audioplayer_slider.dart';
import 'package:wajanja/presentation/widgets/my_image_widget.dart';
import 'package:wajanja/presentation/widgets/play_pause_widget.dart';
import 'package:wajanja/utils/constants/app_svgs.dart';
import 'package:wajanja/utils/extensions/string_extension.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'package:wajanja/utils/mixins.dart';

class PodcastsPage extends ConsumerStatefulWidget {
  const PodcastsPage({super.key});

  @override
  ConsumerState<PodcastsPage> createState() => _PodcastsPageState();
}

class _PodcastsPageState extends ConsumerState<PodcastsPage>
    with AppBarMixin, ThemesMixin {
  int? currentIndex;
  bool? expanded;

  late final AudioPlayer player; // = AudioPlayer();
  late final StreamSubscription<PlayerState> subscription;

  @override
  void initState() {
    super.initState();
    // player = AudioPlayerController.instance.player;

    player = ref.read(audioPlayerNotifierProvider).player;

    subscription = player.playerStateStream.listen((playerState) {
      setState(
        () {
          if (playerState.playing) {
            // _currentPlayer = player;

            log.i("PLAYING STARTED");

            ref
                .read(audioPlayerNotifierProvider.notifier)
                .updateCurrentPlayer(player);
          }
        },
      );
    });

    log.i("CALLED PODCASTS INITSTATE");
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(audioPlayerNotifierProvider);

    log.i("PODCASTS BUILD METHOD CALLED");

    return Scaffold(
      appBar: buildAppBar(context, ref: ref, title: "Podcasts"),
      body: CustomScrollView(
        slivers: [
          SliverList.builder(
            itemBuilder: (context, index) {
              final podcast = podcasts.elementAt(index);
              final isExpanded = currentIndex == index && expanded == true;
              final isPlaying = currentIndex == index && player.playing;

              return GestureDetector(
                onTap: () {
                  ref.read(audioPlayerNotifierProvider).audiobookPlayer.pause();
                  setState(() {
                    expanded =
                        index != currentIndex ? true : !(expanded ?? false);
                    currentIndex = index;
                    if (isPlaying) {
                      log.i("RETURNING SINCE IS PLAYING");
                      return;
                    }
                    loadPodcast(podcast);
                  });
                },
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
                            onTap: () {
                              log.i("Handle toggle playing");

                              ref
                                  .read(audioPlayerNotifierProvider)
                                  .audiobookPlayer
                                  .pause();

                              final canLoadUrl =
                                  (player.audioSource as UriAudioSource?)
                                          ?.uri
                                          .toString() !=
                                      podcast.url;

                              log.i("CAN LOAD URL: $canLoadUrl");

                              // return;

                              setState(() {
                                currentIndex = index;
                                if (isPlaying) {
                                  player.pause();
                                } else if (canLoadUrl) {
                                  loadPodcast(podcast);
                                } else {
                                  player.play();
                                }
                              });
                            },
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        podcast.title,
                                        style: textTheme.titleMedium,
                                      ),
                                      AudioPlayerSlider(
                                        player: player,
                                        timerStyle: textTheme.labelLarge,
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
                                    color: colorScheme.onSurface,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: colorScheme.secondaryContainer,
                      )
                    ],
                  ),
                ).pSymmetric(horizontal: 0, vertical: 16.h),
              );
            },
            itemCount: podcasts.length,
          ).spOnly(left: 16.w, right: 16.w, bottom: 20.h)
        ],
      ),
    );
  }

  void loadPodcast(Podcast podcast) {
    player
      ..setAudioSource(AudioSource.uri(Uri.parse(podcast.url)))
      ..play();
  }
}

class LabelledLists extends StatelessWidget with StatelessThemesMixin {
  const LabelledLists({
    super.key,
    required this.label,
    required this.lists,
  });

  final String label;
  final List<String> lists;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colorScheme(context).outline,
          ),
        ),
        Text("${lists.join(', ')}.")
      ],
    );
  }
}
