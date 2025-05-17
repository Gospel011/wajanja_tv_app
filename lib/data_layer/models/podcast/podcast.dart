// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/utils/constants/enums.dart';

class Podcast {
  final DocumentReference<Map<String, dynamic>> docRef;
  final User postedBy;
  final String title;
  final List<String> speakers;
  final List<String> likes;
  final List<String> dislikes;
  final List<PodcastGenre> genre;
  final String coverphoto;
  final String url;
  Podcast({
    required this.docRef,
    required this.likes,
    required this.dislikes,
    required this.postedBy,
    required this.title,
    required this.speakers,
    required this.genre,
    required this.coverphoto,
    required this.url,
  });

  Podcast copyWith({
    User? postedBy,
    String? title,
    List<String>? speakers,
    List<String>? likes,
    List<String>? dislikes,
    List<PodcastGenre>? genre,
    String? coverphoto,
    String? url,
  }) {
    return Podcast(
      docRef: docRef,
      postedBy: postedBy ?? this.postedBy,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      title: title ?? this.title,
      speakers: speakers ?? this.speakers,
      genre: genre ?? this.genre,
      coverphoto: coverphoto ?? this.coverphoto,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docRef': docRef,
      'postedBy': FirebaseFirestore.instance
          .collection('users')
          .doc('users/${postedBy.email!}'),
      'likes': likes,
      'dislikes': dislikes,
      'title': title,
      'speakers': speakers,
      'genre': genre.map((el) => el.describe).toList(),
      'coverphoto': coverphoto,
      'url': url,
    };
  }

  factory Podcast.fromMap(Map<String, dynamic> map) {
    return Podcast(
      docRef: map['docRef'] as DocumentReference<Map<String, dynamic>>,
      postedBy: User.fromFirestore(
        map['postedBy'] as DocumentSnapshot<Map<String, dynamic>>,
        null,
      ),
      likes: List<String>.from((map['likes'] as List<dynamic>)),
      dislikes: List<String>.from((map['dislikes'] as List<dynamic>)),
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

  @override
  bool operator ==(covariant Podcast other) {
    if (identical(this, other)) return true;

    return other.docRef == docRef &&
        other.postedBy == postedBy &&
        other.title == title &&
        other.coverphoto == coverphoto &&
        other.url == url;
  }

  @override
  int get hashCode {
    return docRef.hashCode ^
        postedBy.hashCode ^
        title.hashCode ^
        coverphoto.hashCode ^
        url.hashCode;
  }
}
