// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'news_provider.dart';

class NewsState {
  final NewsStates states;
  final List<News> news;
  final AppError? error;
  final List<Map<String, dynamic>>? results;
  const NewsState({
    required this.states,
    this.news = const [],
    this.error,
    this.results
  });

  NewsState copyWith({
    NewsStates? states,
    List<News>? news,
    AppError? error,
    List<Map<String, dynamic>>? results,
  }) {
    return NewsState(
      states: states ?? this.states,
      news: news ?? this.news,
      results: results ?? this.results,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'NewsState(states: $states, news: $news, error: $error)';
}
