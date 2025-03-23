// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:wajanja/data_layer/models/news/news_section.dart';
import 'package:wajanja/utils/constants/enums.dart';

class News {
  final String postedBy;
  final String? coverPhoto;
  final String title;
  final Timestamp createdAt;
  final NewsCategory category;
  final List<NewsSection> sections;
  News({
    required this.postedBy,
    this.coverPhoto,
    required this.title,
    required this.createdAt,
    required this.category,
    required this.sections,
  });

  News copyWith({
    String? postedBy,
    String? coverPhoto,
    String? title,
    Timestamp? createdAt,
    NewsCategory? category,
    List<NewsSection>? sections,
  }) {
    return News(
      postedBy: postedBy ?? this.postedBy,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      sections: sections ?? this.sections,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postedBy': postedBy,
      'coverPhoto': coverPhoto,
      'title': title,
      'createdAt': createdAt.toDate().toIso8601String(),
      'category': category.describe,
      'sections': sections.map((x) => x.toMap()).toList(),
    };
  }

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      postedBy: map['postedBy'] as String,
      coverPhoto:
          map['coverPhoto'] != null ? map['coverPhoto'] as String : null,
      title: map['title'] as String,
      createdAt: Timestamp.fromDate(DateTime.parse(map['createdAt'] as String)),
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
    return 'News(postedBy: $postedBy, coverPhoto: $coverPhoto, title: $title, createdAt: $createdAt, category: $category, sections: $sections)';
  }
}
