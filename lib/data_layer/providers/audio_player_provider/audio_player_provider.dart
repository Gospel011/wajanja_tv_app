import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wajanja/data_layer/models/audiobook/audiobook.dart';
import 'package:wajanja/data_layer/providers/audio_player_provider/audio_player_state.dart';
import 'package:wajanja/utils/helpers/logger.dart';

class AudioPlayerNotifier extends Notifier<AudioPlayerState> {
  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _audiobookPlayer = AudioPlayer();
  AudioPlayer? _currentPlayer;
  @override
  build() {
    log.f("AUDIOBOOK NOTIFIER BUILD CALLED");
    log.f("CURRENT NOTIFER PLAYER: $_currentPlayer");

    return AudioPlayerState(
      player: _player,
      audiobookPlayer: _audiobookPlayer,
      currentPlayer: _currentPlayer,
    );
  }

  void refresh() {
    log.f("REFRESH CALLED");
    state = state.copyWith();
  }

  void updateAudiobook({required Audiobook audiobook, int currentChapter = 0}) {
    state =
        state.copyWith(audiobook: audiobook, currentChapter: currentChapter);
  }

  void updateCurrentPlayer(AudioPlayer player) {
    state = state.copyWith(currentPlayer: player);
  }
}

final audioPlayerNotifierProvider =
    NotifierProvider<AudioPlayerNotifier, AudioPlayerState>(() {
  return AudioPlayerNotifier();
});
