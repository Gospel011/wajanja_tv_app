import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/data_layer/providers/audio_player_provider/audio_player_provider.dart';
import 'package:wajanja/data_layer/providers/videos_provider/videos_provider.dart';
import 'package:wajanja/main.dart';
import 'package:wajanja/presentation/pages/videos/video_description.dart';
import 'package:wajanja/presentation/widgets/buttons/my_elevated_button.dart';
import 'package:wajanja/presentation/widgets/icon_container.dart';
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
    final videosState = ref.watch(videosNotifierProvider);
    final bool canShowFAB =
        audioPlayerState.audiobook != null || audioPlayerState.podcast != null;

    log.f("CAN SHOW FAB: $canShowFAB");

    // audioHandler.plstr

    return Scaffold(
      floatingActionButton: canShowFAB
          ? StreamBuilder(
              stream: audioHandler.player.playerStateStream,
              builder: (context, snapshot) {
                return PlayPauseWidget(
                  isPlaying: snapshot.data?.playing ?? false,
                  // isPlaying: false,
                  onTap: () {
                    final player = audioHandler.player;

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
      // body: SingleChildScrollView(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     spacing: 24.h,
      //     children: [
      //       Text(videosState.states.name),
      //       Text("${videosState.videos}"),
      //       MyElevatedButton(
      //         text: "Fetch Videos",
      //         onPressed: () {
      //           ref
      //               .read(videosNotifierProvider.notifier)
      //               .fetchVideos(countryCode: "NG");
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: widget.shell,
    );
  }
}
