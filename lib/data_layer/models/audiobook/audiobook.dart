// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:wajanja/data_layer/models/audiobook/audiobook_chapter.dart';

class Audiobook {
  final String coverphoto;
  final String postedBy;
  final String title;
  final String? description;
  final double averageRating;
  final List<String> likes;
  final List<String> dislikes;
  final List<AudiobookChapter> chapters;
  final Timestamp createdAt;
  Audiobook({
    required this.coverphoto,
    required this.postedBy,
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
    String? postedBy,
    String? title,
    String? description,
    double? averageRating,
    Timestamp? createdAt,
    List<AudiobookChapter>? chapters,
    List<String>? likes,
    List<String>? dislikes,
  }) {
    return Audiobook(
      coverphoto: coverphoto ?? this.coverphoto,
      postedBy: postedBy ?? this.postedBy,
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
      'coverphoto': coverphoto,
      'postedBy': postedBy,
      'title': title,
      'description': description,
      'averageRating': averageRating,
      'createdAt': createdAt.toDate().toIso8601String(),
      'chapters': chapters.map((x) => x.toMap()).toList(),
      'likes': likes,
      'dislikes': dislikes,
    };
  }

  factory Audiobook.fromMap(Map<String, dynamic> map) {
    return Audiobook(
      coverphoto: map['coverphoto'] as String,
      postedBy: map['postedBy'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      averageRating: map['averageRating'] as double,
      likes: List<String>.from((map['likes'] as List<dynamic>)),
      dislikes: List<String>.from((map['dislikes'] as List<dynamic>)),
      createdAt: Timestamp.fromDate(DateTime.parse(map['createdAt'] as String)),
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
  
    return 
      other.coverphoto == coverphoto;
  }

  @override
  int get hashCode {
    return coverphoto.hashCode;
  }
}
