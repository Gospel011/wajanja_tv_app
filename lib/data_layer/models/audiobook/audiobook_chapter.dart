import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AudiobookChapter {
  final String title;
  // final String description;
  final String url;
  final int duration;
  AudiobookChapter({
    required this.title,
    // required this.description,
    required this.url,
    required this.duration,
  });

  Duration get fullDuration => Duration(seconds: duration);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      // 'description': description,
      'url': url,
      'duration': duration,
    };
  }

  factory AudiobookChapter.fromMap(Map<String, dynamic> map) {
    return AudiobookChapter(
      title: map['title'] as String,
      // description: map['description'] as String,
      url: map['url'] as String,
      duration: map['duration'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AudiobookChapter.fromJson(String source) =>
      AudiobookChapter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AudiobookChapter(title: $title, url: $url, duration: $duration)';
}
