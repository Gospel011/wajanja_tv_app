import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wajanja/presentation/widgets/my_loading_widget.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/mixins.dart';

class AudioPlayerSlider extends StatefulWidget {
  const AudioPlayerSlider({
    super.key,
    required this.player,
    this.timerStyle,
    this.showStart = true,
    this.showEnd = true,
  });
  final AudioPlayer player;
  final TextStyle? timerStyle;
  final bool showStart;
  final bool showEnd;

  @override
  State<AudioPlayerSlider> createState() => _AudioPlayerSliderState();
}

class _AudioPlayerSliderState extends State<AudioPlayerSlider> with TimerMixin {
  TimerMode timerMode = TimerMode.descending;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.player.positionStream,
        builder: (context, snapshot) {
          final currentPosition = (snapshot.data?.inSeconds ?? 0);

          // AudioPlayer.clearAssetCache();

          return StreamBuilder(
              stream: widget.player.bufferedPositionStream,
              builder: (context, bufferSnapshot) {
                final bufferedPosition = (bufferSnapshot.data?.inSeconds ?? 0);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 4.w,
                  children: [
                    if (widget.showStart)
                      Text(
                        "0:00",
                        style: widget.timerStyle,
                      ),
                    Expanded(
                      child: widget.player.duration == null
                          ? MyLoadingWidget()
                          : Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.sizeOf(context).width * 0.7),
                              child: Slider(
                                secondaryTrackValue:
                                    bufferedPosition.toDouble(),

                                // inactiveColor: Colors.grey,
                                value: currentPosition.toDouble(),
                                // value: 0,
                                max: (widget.player.duration?.inSeconds ?? 3)
                                    .toDouble(),
                                // max: 1,
                                min: 0,
                                onChanged: (position) {
                                  if (widget.player.duration == null) return;
                                  setState(() {
                                    widget.player.seek(
                                        Duration(seconds: position.toInt()));
                                  });
                                },
                              ),
                            ),
                    ),
                    Builder(builder: (context) {
                      final timer = getTimer(
                        timerMode: timerMode,
                        currentDuration: snapshot.data ?? Duration.zero,
                        fullDuration: widget.player.duration ?? Duration.zero,
                      );

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (timerMode == TimerMode.ascending) {
                              timerMode = TimerMode.descending;
                            } else {
                              timerMode = TimerMode.ascending;
                            }
                          });
                        },
                        child: Text(
                          timer,
                          textAlign: TextAlign.end,
                          style: widget.timerStyle,
                        ),
                      );
                    }),
                  ],
                );
              });
        });
  }
}
