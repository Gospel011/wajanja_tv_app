// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:wajanja/utils/constants/enums.dart';

class Podcast {
  final String postedBy;
  final String title;
  final List<String> speakers;
  final List<PodcastGenre> genre;
  final String coverphoto;
  final String url;
  Podcast({
    required this.postedBy,
    required this.title,
    required this.speakers,
    required this.genre,
    required this.coverphoto,
    required this.url,
  });

  Podcast copyWith({
    String? postedBy,
    String? title,
    List<String>? speakers,
    List<PodcastGenre>? genre,
    String? coverphoto,
    String? url,
  }) {
    return Podcast(
      postedBy: postedBy ?? this.postedBy,
      title: title ?? this.title,
      speakers: speakers ?? this.speakers,
      genre: genre ?? this.genre,
      coverphoto: coverphoto ?? this.coverphoto,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postedBy': postedBy,
      'title': title,
      'speakers': speakers,
      'genre': genre.map((el) => el.describe).toList(),
      'coverphoto': coverphoto,
      'url': url,
    };
  }

  factory Podcast.fromMap(Map<String, dynamic> map) {
    return Podcast(
      postedBy: map['postedBy'] as String,
      title: map['title'] as String,
      speakers: List<String>.from((map['speakers'] as List<dynamic>)),
      genre: List<PodcastGenre>.from((map['genre'] as List<dynamic>)
          .map((el) => PodcastGenre.fromString(el as String))),
      coverphoto: map['coverphoto'] as String,
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Podcast.fromJson(String source) =>
      Podcast.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Podcast(postedBy: $postedBy, title: $title, speakers: $speakers, genre: ${genre.map((el) => el.describe).toList()}, coverphoto: $coverphoto, url: $url)';
  }
}
