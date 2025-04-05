// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:just_audio/just_audio.dart';

import 'package:wajanja/data_layer/models/audiobook/audiobook.dart';
import 'package:wajanja/data_layer/models/podcast/podcast.dart';

class AudioPlayerState {
  final AudioPlayer player;
  final AudioPlayer audiobookPlayer;
  final AudioPlayer? currentPlayer;
  final Audiobook? audiobook;
  final int? currentChapter;
  final Podcast? podcast;
  AudioPlayerState({
    required this.player,
    required this.audiobookPlayer,
    this.currentPlayer,
    this.audiobook,
    this.currentChapter,
    this.podcast,
  });

  AudioPlayerState copyWith({
    AudioPlayer? player,
    AudioPlayer? audiobookPlayer,
    AudioPlayer? currentPlayer,
    Audiobook? audiobook,
    int? currentChapter,
    Podcast? podcast,
  }) {
    return AudioPlayerState(
      player: player ?? this.player,
      audiobookPlayer: audiobookPlayer ?? this.audiobookPlayer,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      audiobook: audiobook ?? this.audiobook,
      currentChapter: currentChapter ?? this.currentChapter,
      podcast: podcast ?? this.podcast,
    );
  }
}
