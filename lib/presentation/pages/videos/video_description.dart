import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/data_layer/models/videos/video.dart';
import 'package:wajanja/data_layer/providers/audio_player_provider/audio_player_provider.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/data_layer/providers/videos_provider/videos_provider.dart';
import 'package:wajanja/main.dart';
import 'package:wajanja/my_tests/sample_models.dart';
import 'package:wajanja/presentation/components/my_video_player.dart';
import 'package:wajanja/presentation/components/video_row.dart';
import 'package:wajanja/presentation/widgets/icon_container.dart';
import 'package:wajanja/presentation/widgets/my_expandable_text.dart';
import 'package:wajanja/utils/constants/app_svgs.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/string_extension.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'package:wajanja/utils/mixins.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoDescription extends ConsumerStatefulWidget {
  const VideoDescription({
    super.key,
    this.video,
    this.videoId,
  });
  final Video? video;
  final String? videoId;

  @override
  ConsumerState<VideoDescription> createState() => _VideoDescriptionState();
}

class _VideoDescriptionState extends ConsumerState<VideoDescription>
    with UiInfoMixin, ThemesMixin, DebounceMixin {
  VideoPlayerController? _playerController;
  YoutubePlayerController? _youtubePlayerController;
  late bool isYoutube;
  bool? isFullScreen;

  Video? video;
  User? user;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      user = ref.read(authNotifierProvider).user!;
    });

    if (widget.video == null) return;

    video = widget.video;

    setupPlayer();
  }

  Future<void> setupPlayer() async {
    final uri = Uri.parse(video!.url ?? video!.youtubeUrl ?? video!.vimeoUrl!);

    isYoutube = video!.url == null &&
        video!.vimeoUrl == null &&
        video!.youtubeUrl != null;

    log.i("PARSED URI: $uri");
    // await Future.wait([
    //   ref.read(audioPlayerNotifierProvider).player.pause(),
    //   ref.read(audioPlayerNotifierProvider).audiobookPlayer.pause(),
    // ]);

    await audioHandler.pause();

    ref.read(audioPlayerNotifierProvider.notifier).refresh();

    if (!mounted) return;

    setState(() {
      if (isYoutube) {
        final String? videoId =
            YoutubePlayer.convertUrlToId(video!.youtubeUrl!);

        if (videoId == null) {
          showSnackMessage(
              context, "This video contains an invalid youtube url",
              error: true);
          return;
        }

        log.i("VIDEOID: $videoId");

        _youtubePlayerController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: YoutubePlayerFlags(enableCaption: false),
        );

        // _youtubePlayerController.

        isFullScreen = _youtubePlayerController?.value.isFullScreen;

        _youtubePlayerController?.addListener(youtubePlayerListener);

        confirmVideoIsPlaying();
      } else {
        _playerController = VideoPlayerController.networkUrl(
          uri,
        )
          ..initialize()
          ..play();
      }
    });
  }

  @override
  void dispose() {
    _youtubePlayerController?.dispose();
    _playerController?.dispose();

    super.dispose();
  }

  // ColorScheme get colorScheme => Theme.of(context).colorScheme;

  void youtubePlayerListener() {
    if (_youtubePlayerController?.value.isFullScreen != null &&
        _youtubePlayerController?.value.isFullScreen != isFullScreen) {
      setState(() {
        isFullScreen = _youtubePlayerController!.value.isFullScreen;
      });
    }

    // log.f("value ${_youtubePlayerController?.value}");

    // switch (_youtubePlayerController!.value.playerState) {
    //   case PlayerState.:

    //     break;
    //   default:
    // }
  }

  void playVideo(Video videoToPlay) {
    if (videoToPlay.isYoutube) {
      final videoId = YoutubePlayer.convertUrlToId(
        videoToPlay.youtubeUrl!,
      );

      if (videoId == null) {
        showSnackMessage(context, "This video contains an invalid youtube url",
            error: true);

        return;
      }

      _youtubePlayerController!.load(videoId);

      setState(() {
        video = videoToPlay;
      });

      log.f("ABOOUT TO DEBOUNCE");

      confirmVideoIsPlaying();
    }
  }

  void confirmVideoIsPlaying() {
    Future.delayed(const Duration(seconds: 30), () {
      if (_youtubePlayerController != null &&
          _youtubePlayerController?.value.playerState != PlayerState.playing) {
        if (!mounted) return;
        showSnackMessage(
          context,
          "This video is taking too long to load, please check your internet connection or keep waiting",
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    log.i("Video: ${video?.title}");
    log.i("widget video: ${widget.video?.title}");
    log.i("VIDEO URL: ${widget.video?.youtubeUrl}");
    return Scaffold(
      body: video == null
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyVideoPlayer(
                    video: video!,
                    videoPlayerController: _playerController,
                    youtubePlayerController: _youtubePlayerController,
                  ),
                  Expanded(
                      child: CustomScrollView(
                    slivers: [
                      if (video!.description != null)
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 10.h,
                          ),
                        ),
                      if (video!.description != null)
                        SliverToBoxAdapter(
                            child: Text(
                          video!.title.capitalize,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ).pSymmetric()),
                      SliverToBoxAdapter(
                          child: SizedBox(
                        height: 26.h,
                      )),
                      SliverToBoxAdapter(
                        child: Builder(builder: (context) {
                          final bool liked = video!.likes.contains(user?.email);
                          final bool disliked =
                              video!.dislikes.contains(user?.email);

                          return Row(
                            spacing: 20.w,
                            children: [
                              IconContainer(
                                icon: AppSvgs.like.assetCopy(
                                  color: liked ? colorScheme.surface : null,
                                ),
                                backgroundColor: liked
                                    ? colorScheme.primary
                                    : colorScheme.secondaryContainer,
                                onTap: () async {
                                  if (video == null) return;

                                  final newVideo = await ref
                                      .read(videosNotifierProvider.notifier)
                                      .likeVideo(video!);

                                  if (newVideo != null) {
                                    setState(() {
                                      video = newVideo;
                                    });
                                  }
                                },
                              ),
                              IconContainer(
                                icon: AppSvgs.dislike.assetCopy(
                                  color: disliked ? colorScheme.surface : null,
                                ),
                                backgroundColor: disliked
                                    ? colorScheme.primary
                                    : colorScheme.secondaryContainer,
                                onTap: () async {
                                  if (video == null) return;

                                  final newVideo = await ref
                                      .read(videosNotifierProvider.notifier)
                                      .dislikeVideo(video!);

                                  if (newVideo != null) {
                                    setState(() {
                                      video = newVideo;
                                    });
                                  }
                                },
                              ),
                              IconContainer(
                                onTap: () {},
                                icon: AppSvgs.share,
                              ),
                            ],
                          ).pSymmetric();
                        }),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 18.h,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: colorScheme.secondary,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            spacing: 10.h,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Description",
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.tertiaryFixed,
                                ),
                              ),
                              MyExpandableText(
                                video!.description!,
                                textStyle: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ).pSymmetric(),
                      ),
                      SliverToBoxAdapter(
                          child: SizedBox(
                        height: 28.h,
                      )),
                      SliverToBoxAdapter(child: Builder(builder: (context) {
                        final nextVideosList = ref
                            .read(videosNotifierProvider)
                            .videos
                            .sublist(ref
                                    .read(videosNotifierProvider)
                                    .videos
                                    .indexOf(video!) +
                                1);

                        late final List<Video> nextVideos;

                        if (nextVideosList.isNotEmpty) {
                          nextVideos = nextVideosList;
                        } else {
                          nextVideos = [
                            ...ref.read(videosNotifierProvider).videos
                          ]..shuffle();
                        }

                        nextVideos.removeWhere((el) => el == video);

                        return VideoRow(
                            title: "Next up",
                            videos: nextVideos,
                            maxLength: 4,
                            onVideoTap: (newVideo) {
                              if (video == newVideo) {
                                log.i(
                                  "RETURNING SINCE SAME VIDEO WAS CLICKED",
                                );

                                return;
                              }
                              playVideo(newVideo);
                            });
                      })),
                      SliverToBoxAdapter(
                          child: SizedBox(
                        height: 24.h,
                      )),
                    ],
                  ))
                ],
              ),
            ),
    );
  }
}
