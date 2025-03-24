import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wajanja/data_layer/providers/audio_player_provider/audio_player_provider.dart';
import 'package:wajanja/presentation/pages/videos/video_description.dart';
import 'package:wajanja/presentation/widgets/play_pause_widget.dart';
import 'package:wajanja/utils/constants/app_svgs.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'package:wajanja/utils/mixins.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> with ThemesMixin {
  static final navIcons = [
    AppSvgs.video,
    AppSvgs.news,
    AppSvgs.audiobook,
    AppSvgs.podcast
  ];

  // get ref => null;

  @override
  Widget build(BuildContext context) {
    final audioPlayerState = ref.watch(audioPlayerNotifierProvider);

    return Scaffold(
      floatingActionButton: audioPlayerState.currentPlayer != null
          ? StreamBuilder(
              stream: audioPlayerState.currentPlayer!.playerStateStream,
              builder: (context, snapshot) {
                return PlayPauseWidget(
                  isPlaying: snapshot.data?.playing ?? false,
                  // isPlaying: false,
                  onTap: () {
                    final player = audioPlayerState.currentPlayer!;

                    setState(() {
                      player.playing ? player.pause() : player.play();
                    });
                  },
                );
              })
          : null,
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: BorderRadius.circular(16.r)),
            constraints: BoxConstraints(
                minWidth: MediaQuery.sizeOf(context).width * 0.63),
            padding: EdgeInsets.all(20.r),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List<Widget>.generate(navIcons.length, (index) {
                  final icon = navIcons.elementAt(index);

                  return IconContainer(
                    backgroundColor: widget.shell.currentIndex == index
                        ? colorScheme.primary
                        : null,
                    onTap: () {
                      widget.shell.goBranch(index);
                    },
                    icon: icon.assetCopy(
                      color: widget.shell.currentIndex == index
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ).pOnly(left: 0, right: 0, top: 0, bottom: 24.h),
      body: widget.shell,
    );
  }
}
