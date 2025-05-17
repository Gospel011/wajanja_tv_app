// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:wajanja/data_layer/models/news/news_section.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/utils/constants/enums.dart';

class News {
  final DocumentReference<Map<String, dynamic>> docRef;
  final User postedBy;
  final String coverPhoto;
  final String title;
  final Timestamp createdAt;
  final NewsCategory category;
  final List<NewsSection> sections;
  final List<String> likes;
  final List<String> dislikes;

  News({
    required this.docRef,
    required this.postedBy,
    required this.coverPhoto,
    required this.title,
    required this.createdAt,
    required this.category,
    required this.sections,
    required this.likes,
    required this.dislikes,
  });

  String get shortDate => DateFormat("MMM dd, yyyy").format(createdAt.toDate());

  News copyWith({
    User? postedBy,
    String? coverPhoto,
    String? title,
    Timestamp? createdAt,
    NewsCategory? category,
    List<NewsSection>? sections,
    List<String>? likes,
    List<String>? dislikes,
  }) {
    return News(
      docRef: docRef,
      postedBy: postedBy ?? this.postedBy,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      sections: sections ?? this.sections,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docRef': docRef,
      'postedBy': FirebaseFirestore.instance
          .collection('users')
          .doc('users/${postedBy.email!}'),
      'coverphoto': coverPhoto,
      'title': title,
      'createdAt': createdAt,
      'category': category.describe,
      'sections': sections.map((x) => x.toMap()).toList(),
      'likes': likes,
      'dislikes': dislikes,
    };
  }

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      docRef: map['docRef'] as DocumentReference<Map<String, dynamic>>,
      postedBy: User.fromFirestore(
        map['postedBy'] as DocumentSnapshot<Map<String, dynamic>>,
        null,
      ),
      likes: List<String>.from((map['likes'] as List<dynamic>)),
      dislikes: List<String>.from((map['dislikes'] as List<dynamic>)),
      coverPhoto: map['coverphoto'] as String,
      title: map['title'] as String,
      createdAt: map['createdAt'] as Timestamp,
      category: NewsCategory.fromString(map['category'] as String),
      sections: List<NewsSection>.from(
        (map['sections'] as List<dynamic>).map<NewsSection>(
          (x) => NewsSection.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory News.fromJson(String source) =>
      News.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'News(title: $title, likes: $likes, dislikes: $dislikes)';
  }

  @override
  bool operator ==(covariant News other) {
    if (identical(this, other)) return true;

    return other.docRef == docRef &&
        other.postedBy == postedBy &&
        other.coverPhoto == coverPhoto &&
        other.title == title &&
        other.createdAt == createdAt &&
        other.category == category;
  }

  @override
  int get hashCode {
    return docRef.hashCode ^
        postedBy.hashCode ^
        coverPhoto.hashCode ^
        title.hashCode ^
        createdAt.hashCode ^
        category.hashCode;
  }
}
