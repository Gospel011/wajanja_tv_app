// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'podcast_provider.dart';

class PodcastState {
  final PodcastStates states;
  final List<Podcast> podcasts;
  final AppError? error;
  final List<Map<String, dynamic>>? results;
  const PodcastState({
    required this.states,
    this.podcasts = const [],
    this.error,
    this.results
  });

  PodcastState copyWith({
    PodcastStates? states,
    List<Podcast>? podcasts,
    AppError? error,
    List<Map<String, dynamic>>? results,
  }) {
    return PodcastState(
      states: states ?? this.states,
      podcasts: podcasts ?? this.podcasts,
      results: results ?? this.results,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'PodcastState(states: $states, podcasts: $podcasts, error: $error)';
}
