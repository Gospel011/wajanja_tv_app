// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:wajanja/data_layer/models/audiobook/audiobook_chapter.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';

class Audiobook {
  final DocumentReference<Map<String, dynamic>> docRef;
  final User postedBy;
  final String coverphoto;
  final String title;
  final String? description;
  final double averageRating;
  final List<String> likes;
  final List<String> dislikes;
  final List<AudiobookChapter> chapters;
  final Timestamp createdAt;
  Audiobook({
    required this.docRef,
    required this.postedBy,
    required this.coverphoto,
    required this.title,
    required this.averageRating,
    this.description,
    required this.createdAt,
    required this.chapters,
    required this.likes,
    required this.dislikes,
  });

  Audiobook copyWith({
    String? coverphoto,
    User? postedBy,
    String? title,
    String? description,
    double? averageRating,
    Timestamp? createdAt,
    List<AudiobookChapter>? chapters,
    List<String>? likes,
    List<String>? dislikes,
  }) {
    return Audiobook(
      docRef: docRef,
      postedBy: postedBy ?? this.postedBy,
      coverphoto: coverphoto ?? this.coverphoto,
      title: title ?? this.title,
      description: description ?? this.description,
      averageRating: averageRating ?? this.averageRating,
      createdAt: createdAt ?? this.createdAt,
      chapters: chapters ?? this.chapters,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docRef': docRef,
      'coverphoto': coverphoto,
      'postedBy': FirebaseFirestore.instance
          .collection('users')
          .doc('users/${postedBy.email!}'),
      'title': title,
      'description': description,
      'averageRating': averageRating,
      'createdAt': createdAt,
      'chapters': chapters.map((x) => x.toMap()).toList(),
      'likes': likes,
      'dislikes': dislikes,
    };
  }

  factory Audiobook.fromMap(Map<String, dynamic> map) {
    return Audiobook(
      docRef: map['docRef'] as DocumentReference<Map<String, dynamic>>,
      coverphoto: map['coverphoto'] as String,
      postedBy: User.fromFirestore(
        map['postedBy'] as DocumentSnapshot<Map<String, dynamic>>,
        null,
      ),
      title: map['title'] as String,
      description: map['description'] as String?,
      averageRating: double.parse(map['averageRating'].toString()),
      likes: List<String>.from((map['likes'] as List<dynamic>)),
      dislikes: List<String>.from((map['dislikes'] as List<dynamic>)),
      createdAt: map['createdAt'] as Timestamp,
      chapters: List<AudiobookChapter>.from(
        (map['chapters'] as List<dynamic>).map<AudiobookChapter>(
          (x) => AudiobookChapter.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Audiobook.fromJson(String source) =>
      Audiobook.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Audiobook(coverphoto: $coverphoto, postedBy: $postedBy)';
  }

  @override
  bool operator ==(covariant Audiobook other) {
    if (identical(this, other)) return true;

    return other.coverphoto == coverphoto;
  }

  @override
  int get hashCode {
    return coverphoto.hashCode;
  }
}
