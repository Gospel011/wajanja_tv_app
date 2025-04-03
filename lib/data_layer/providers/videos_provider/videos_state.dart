// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'videos_provider.dart';

class VideosState {
  final VideosStates states;
  final List<Video> videos;
  final AppError? error;
  final List<Map<String, dynamic>>? results;
  const VideosState({
    required this.states,
    this.videos = const [],
    this.error,
    this.results
  });

  VideosState copyWith({
    VideosStates? states,
    List<Video>? videos,
    AppError? error,
    List<Map<String, dynamic>>? results,
  }) {
    return VideosState(
      states: states ?? this.states,
      videos: videos ?? this.videos,
      results: results ?? this.results,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'VideosState(states: $states, videos: $videos, error: $error)';
}
