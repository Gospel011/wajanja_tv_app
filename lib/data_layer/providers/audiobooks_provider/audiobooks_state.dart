// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'audiobooks_provider.dart';

class AudiobooksState {
  final AudiobooksStates states;
  final List<Audiobook> audiobooks;
  final AppError? error;
  final List<Map<String, dynamic>>? results;
  const AudiobooksState(
      {required this.states,
      this.audiobooks = const [],
      this.error,
      this.results});

  AudiobooksState copyWith({
    AudiobooksStates? states,
    List<Audiobook>? audiobooks,
    AppError? error,
    List<Map<String, dynamic>>? results,
  }) {
    return AudiobooksState(
      states: states ?? this.states,
      audiobooks: audiobooks ?? this.audiobooks,
      results: results ?? this.results,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'AudiobooksState(states: $states, audiobooks: $audiobooks, error: $error)';
}
