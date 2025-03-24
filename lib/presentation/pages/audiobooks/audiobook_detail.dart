import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wajanja/data_layer/models/audiobook/audiobook.dart';
import 'package:wajanja/data_layer/models/audiobook/audiobook_chapter.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/presentation/widgets/audiobook_chapter_tile.dart';
import 'package:wajanja/presentation/widgets/audiobook_cover.dart';
import 'package:wajanja/presentation/widgets/my_image_widget.dart';
import 'package:wajanja/presentation/widgets/my_loading_widget.dart';
import 'package:wajanja/presentation/widgets/play_pause_widget.dart';
import 'package:wajanja/utils/constants/app_svgs.dart';
import 'package:wajanja/utils/extensions/string_extension.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/mixins.dart';

class AudiobookDetail extends ConsumerStatefulWidget {
  const AudiobookDetail({
    super.key,
    required this.audiobook,
  });
  final Audiobook audiobook;

  @override
  ConsumerState<AudiobookDetail> createState() => _AudiobookDetailState();
}

class _AudiobookDetailState extends ConsumerState<AudiobookDetail>
    with ThemesMixin, TimerMixin {
  Audiobook? audiobook;
  int? currentIndex;
  User? postedBy;

  final AudioPlayer player = AudioPlayer();
  late final ConcatenatingAudioSource playlist;

  @override
  void initState() {
    super.initState();
    audiobook = widget.audiobook;
    currentIndex = 0;
    postedBy = ref.read(authNotifierProvider).user;

    playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      children: List<AudioSource>.generate(
        audiobook!.chapters.length,
        (index) {
          return AudioSource.uri(
              Uri.parse(audiobook!.chapters.elementAt(index).url));
        },
      ),
    );

    player
      ..setAudioSource(
        playlist,
        initialIndex: 0,
        initialPosition: Duration.zero,
      )
      ..setVolume(1)
      ..play();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  AudiobookChapter get currentChapter =>
      audiobook!.chapters.elementAt(currentIndex!);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          "Chapter ${currentIndex! + 1}",
          style: textTheme.bodySmall,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AudiobookCoverAndAuthorInfo(
              audiobook: audiobook,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 24.h,
            ),
          ),
          SliverToBoxAdapter(
              child: Column(
            spacing: 18.h,
            children: [
              StreamBuilder(
                  stream: player.positionStream,
                  builder: (context, snapshot) {
                    final currentPosition = (snapshot.data?.inSeconds ?? 0);

                    return StreamBuilder(
                        stream: player.bufferedPositionStream,
                        builder: (context, bufferSnapshot) {
                          final bufferedPosition =
                              (bufferSnapshot.data?.inSeconds ?? 0);
                          return Row(
                            children: [
                              Text("0:00"),
                              Expanded(
                                child: player.duration == null
                                    ? MyLoadingWidget()
                                    : Slider(
                                        secondaryTrackValue:
                                            bufferedPosition.toDouble(),

                                        // inactiveColor: Colors.grey,
                                        value: currentPosition.toDouble(),
                                        // value: 0,
                                        max: (player.duration?.inSeconds ?? 3)
                                            .toDouble(),
                                        // max: 1,
                                        min: 0,
                                        onChanged: (position) {
                                          if (player.duration == null) return;
                                          setState(() {
                                            player.seek(Duration(
                                                seconds: position.toInt()));
                                          });
                                        },
                                      ),
                              ),
                              Text(descendingTimerMixin(
                                  snapshot.data ?? Duration.zero,
                                  player.duration ?? Duration.zero)),
                            ],
                          );
                        });
                  }),
              Builder(builder: (context) {
                final liked = audiobook!.likes.contains(postedBy!.email);
                final disliked = audiobook!.dislikes.contains(postedBy!.email);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (liked) {
                            audiobook = audiobook!.copyWith(
                              likes: audiobook!.likes
                                  .where((el) => el != postedBy!.email)
                                  .toList(),
                            );
                          } else {
                            audiobook = audiobook!.copyWith(
                              dislikes: audiobook!.dislikes
                                  .where((el) => el != postedBy!.email)
                                  .toList(),
                              likes: audiobook!.likes..add(postedBy!.email!),
                            );
                          }
                        });
                      },
                      child: SizedBox(
                        width: 40.r,
                        child: (liked ? AppSvgs.likeFilled : AppSvgs.like)
                            .assetCopy(
                          width: 40.r,
                          height: 40.r,
                          color: liked
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        spacing: 24.w,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // currentIndex != null && currentIndex! > 0
                          //     ?
                          GestureDetector(
                            onTap: () {
                              if (currentIndex == null || currentIndex! <= 0) {
                                return;
                              }

                              setState(() {
                                currentIndex = currentIndex! - 1;
                                player.seek(Duration.zero, index: currentIndex);
                              });
                            },
                            child: Icon(
                              Icons.fast_rewind_rounded,
                              size: 56.r,
                            ),
                          ),
                          // : SizedBox(width: 56.w),
                          PlayPauseWidget(
                              isPlaying: player.playing,
                              onTap: () {
                                setState(() {
                                  if (player.playing) {
                                    player.pause();
                                  } else {
                                    player.play();
                                  }
                                });
                              }),
                          // currentIndex != null &&
                          //         currentIndex! < audiobook!.chapters.length - 1
                          //     ?
                          GestureDetector(
                            onTap: () {
                              if (!player.hasNext) {
                                return;
                              }

                              setState(() {
                                currentIndex = currentIndex! + 1;
                                player.seekToNext();
                              });
                            },
                            child: Icon(
                              Icons.fast_forward_rounded,
                              size: 56.r,
                            ),
                          ),
                          // : SizedBox(
                          //     width: 56.r,
                          //   ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (disliked) {
                            audiobook = audiobook!.copyWith(
                              dislikes: audiobook!.dislikes
                                  .where((el) => el != postedBy!.email)
                                  .toList(),
                            );
                          } else {
                            audiobook = audiobook!.copyWith(
                                likes: audiobook!.likes
                                    .where((el) => el != postedBy!.email)
                                    .toList(),
                                dislikes: audiobook!.likes
                                  ..add(postedBy!.email!));
                          }
                        });
                      },
                      child: SizedBox(
                        width: 40.r,
                        child:
                            (disliked ? AppSvgs.dislikeFilled : AppSvgs.dislike)
                                .assetCopy(
                          width: 40.r,
                          height: 40.r,
                          color: disliked
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          )).spSymmetric(),
          SliverToBoxAdapter(
              child: SizedBox(
            height: 26.h,
          )),
          SliverList.builder(
            itemBuilder: (context, index) {
              final chapter = audiobook!.chapters.elementAt(index);
              final bool isCurrentChapter = index == currentIndex;

              return AudiobookChapterTile(
                  chapter: chapter,
                  selected: isCurrentChapter,
                  isPlaying: player.playing,
                  onPlay: () {
                    () {
                      setState(() {
                        player.playing ? player.pause() : player.play();
                      });
                    };
                  },
                  onTap: () {
                    setState(() {
                      currentIndex = index;

                      player.seek(Duration.zero, index: index);
                    });
                  });
            },
            itemCount: audiobook!.chapters.length,
          )
        ],
      ),
    );
  }
}
