import 'package:just_audio/just_audio.dart';

class AudioPlayerController {
  final AudioPlayer player = AudioPlayer();

  AudioPlayerController._();

  static final AudioPlayerController _instance = AudioPlayerController._();

  static AudioPlayerController get instance => _instance;

  // AudioPlayer get player => _player;

  // factory AudioPlayerController() {
  //   return AudioPlayerController._();
  // }
}
