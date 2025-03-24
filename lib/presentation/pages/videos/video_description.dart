import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:wajanja/data_layer/models/controllers/audioplayer_controller.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/data_layer/models/videos/video.dart';
import 'package:wajanja/data_layer/providers/audio_player_provider/audio_player_provider.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/my_tests/sample_models.dart';
import 'package:wajanja/presentation/components/my_video_player.dart';
import 'package:wajanja/presentation/components/video_row.dart';
import 'package:wajanja/presentation/widgets/my_expandable_text.dart';
import 'package:wajanja/utils/constants/app_svgs.dart';
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
    with UiInfoMixin, ThemesMixin {
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
    await Future.wait([
      ref.read(audioPlayerNotifierProvider).player.pause(),
      ref.read(audioPlayerNotifierProvider).audiobookPlayer.pause(),
    ]);

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
  }

  @override
  Widget build(BuildContext context) {
    log.i("Video: ${video?.title}");
    log.i("widget video: ${widget.video?.title}");
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
                          video!.title,
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
                                onTap: () {
                                  setState(() {
                                    if (liked) {
                                      video = video!.copyWith(
                                        likes: video!.likes
                                            .where((el) => el != user!.email)
                                            .toList(),
                                      );
                                    } else {
                                      video = video!.copyWith(
                                        dislikes: video!.dislikes
                                            .where((el) => el != user!.email)
                                            .toList(),
                                        likes: video!.likes..add(user!.email!),
                                      );
                                    }
                                  });
                                },
                              ),
                              IconContainer(
                                icon: AppSvgs.dislike.assetCopy(
                                  color: disliked ? colorScheme.surface : null,
                                ),
                                backgroundColor: disliked
                                    ? colorScheme.primary
                                    : colorScheme.secondaryContainer,
                                onTap: () {
                                  setState(() {
                                    if (disliked) {
                                      video = video!.copyWith(
                                        dislikes: video!.dislikes
                                            .where((el) => el != user!.email)
                                            .toList(),
                                      );
                                    } else {
                                      video = video!.copyWith(
                                          likes: video!.likes
                                              .where((el) => el != user!.email)
                                              .toList(),
                                          dislikes: video!.likes
                                            ..add(user!.email!));
                                    }
                                  });
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
                      SliverToBoxAdapter(
                          child: VideoRow(
                              title: "Next up",
                              videos: videos,
                              maxLength: 4,
                              onVideoTap: (newVideo) {
                                if (video == newVideo) {
                                  log.i(
                                    "RETURNING SINCE SAME VIDEO WAS CLICKED",
                                  );

                                  return;
                                }
                                if (newVideo.isYoutube) {
                                  final videoId = YoutubePlayer.convertUrlToId(
                                    newVideo.youtubeUrl!,
                                  );

                                  if (videoId == null) {
                                    showSnackMessage(context,
                                        "This video contains an invalid youtube url",
                                        error: true);

                                    return;
                                  }

                                  _youtubePlayerController!.load(videoId);

                                  setState(() {
                                    video = newVideo;
                                  });
                                }
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

class IconContainer extends StatelessWidget {
  const IconContainer({
    super.key,
    required this.icon,
    this.size,
    this.backgroundColor,
    this.padding,
    this.onTap,
  });

  final Widget icon;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final double? size;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? EdgeInsets.all(4.r),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ??
              Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: icon,
      ),
    );
  }
}
