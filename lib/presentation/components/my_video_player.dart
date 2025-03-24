import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wajanja/data_layer/models/videos/video.dart';
import 'package:wajanja/presentation/widgets/image_place_holder_widget.dart';
import 'package:wajanja/utils/mixins.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MyVideoPlayer extends StatefulWidget {
  const MyVideoPlayer({
    super.key,
    required this.video,
    this.youtubePlayerController,
    this.videoPlayerController,
  });
  final Video video;
  final YoutubePlayerController? youtubePlayerController;
  final VideoPlayerController? videoPlayerController;

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> with UiInfoMixin {
  // VideoPlayerController? _playerController;
  // YoutubePlayerController? _youtubePlayerController;
  late bool isYoutube;
  // bool? isFullScreen;

  @override
  void initState() {
    super.initState();
    // final uri = Uri.parse(
    //     widget.video.url ?? widget.video.youtubeUrl ?? widget.video.vimeoUrl!);

    isYoutube = widget.video.url == null &&
        widget.video.vimeoUrl == null &&
        widget.video.youtubeUrl != null;

    // final uri = Uri.parse(
    //   "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
    // );

    // log.i("PARSED URI: $uri");

    // if (isYoutube) {
    //   final String? videoId =
    //       YoutubePlayer.convertUrlToId(widget.video.youtubeUrl!);

    //   if (videoId == null) {
    //     showSnackMessage(context, "This video contains an invalid youtube url",
    //         error: true);
    //     return;
    //   }

    //   log.i("VIDEOID: $videoId");

    //   _youtubePlayerController = YoutubePlayerController(
    //     initialVideoId: videoId,
    //     flags: YoutubePlayerFlags(enableCaption: false),
    //   );

    //   isFullScreen = _youtubePlayerController?.value.isFullScreen;

    //   _youtubePlayerController?.addListener(youtubePlayerListener);
    // } else {
    //   _playerController = VideoPlayerController.networkUrl(
    //     uri,
    //   )
    //     ..initialize()
    //     ..play();
    // }
  }

  // @override
  // void dispose() {
  //   _youtubePlayerController?.dispose();
  //   _playerController?.dispose();
  //   super.dispose();
  // }

  ColorScheme get colorScheme => Theme.of(context).colorScheme;

  // void youtubePlayerListener() {
  //   if (_youtubePlayerController?.value.isFullScreen != null &&
  //       _youtubePlayerController?.value.isFullScreen != isFullScreen) {
  //     setState(() {
  //       isFullScreen = _youtubePlayerController!.value.isFullScreen;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // log.i("is full screen: $isFullScreen");
    // log.i(
    // "is full screen from controller: ${widget.youtubePlayerController?.value.isFullScreen}");

    return isYoutube
        ? (widget.youtubePlayerController == null
            ? AspectRatio(
                aspectRatio: 16 / 9, child: ImageLoadingPlaceHolderWidget())
            : YoutubePlayerBuilder(
                player: YoutubePlayer(
                  // width: 100,
                  controller: widget.youtubePlayerController!,
                  // topActions: [
                  //   Spacer(),
                  //   IconButton(
                  //     onPressed: () {

                  //       // _youtubePlayerController!.updateValue(YoutubePlayerValue());
                  //     },
                  //     icon: Icon(Icons.closed_caption_off),
                  //   ),
                  //   SizedBox(
                  //     width: 16.w,
                  //   ),
                  // ],
                  progressColors: ProgressBarColors(
                    backgroundColor: colorScheme.outlineVariant,
                    playedColor: colorScheme.primary,
                    bufferedColor: colorScheme.surfaceTint,
                    handleColor: colorScheme.primary,
                  ),
                ),
                builder: (BuildContext context, Widget player) {
                  return player;
                },
              ))
        : SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outline),
                  child: VideoPlayer(widget.videoPlayerController!)),
            ),
          );
  }

  // String extractVideoId(String youtubeUrl) {
  //   final bool fromSearch = youtubeUrl.contains("youtube.com");
  //   final bool fromShare = youtubeUrl.contains("youtu.be");

  //   late String url;

  //   if (fromSearch) {
  //     final urlList = youtubeUrl.split("v=");

  //     if (urlList.length < 2) throw "Invalid url";

  //     url = urlList.last;
  //   } else if (fromShare) {
  //     List<String> urlList = youtubeUrl.split("youtu.be/");

  //     if (urlList.length < 2) throw "Invalid url";

  //     urlList = urlList.last.split("?si=");

  //     if (urlList.length < 2) throw "Invalid url";

  //     url = urlList.last;
  //   }

  //   return url;
  // }
}
