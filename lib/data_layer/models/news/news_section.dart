// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:wajanja/utils/constants/enums.dart';

class NewsSection {
  final NewsSectionType sectionType;
  final String? text;
  final List<String>? images;
  const NewsSection({
    required this.sectionType,
    this.text,
    this.images,
  });

  NewsSection copyWith({
    NewsSectionType? sectionType,
    String? text,
    List<String>? images,
  }) {
    return NewsSection(
      sectionType: sectionType ?? this.sectionType,
      text: text ?? this.text,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sectionType': sectionType.describe,
      'text': text,
      'images': images,
    };
  }

  factory NewsSection.fromMap(Map<String, dynamic> map) {
    return NewsSection(
      sectionType: NewsSectionType.fromString(map['sectionType'] as String),
      text: map['text'] != null ? map['text'] as String : null,
      images: map['images'] != null
          ? List<String>.from((map['images'] as List<dynamic>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsSection.fromJson(String source) =>
      NewsSection.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'NewsSection(sectionType: $sectionType, text: $text, images: $images)';
}
