// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';

import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/utils/constants/enums.dart';

class Video {
  final DocumentReference<Map<String, dynamic>> docRef;
  final String title;
  final String? description;
  final String? coverPhotoPortrait;
  final User postedBy;
  final String? url;
  final String? youtubeUrl;
  final String? vimeoUrl;
  final VideoCategories category;
  final List<String> likes;
  final List<String> dislikes;
  final String country;
  final String city;
  final Timestamp createdAt;
  Video({
    required this.docRef,
    required this.title,
    this.description,
    this.coverPhotoPortrait,
    required this.postedBy,
    this.url,
    this.youtubeUrl,
    this.vimeoUrl,
    required this.category,
    required this.likes,
    required this.dislikes,
    required this.country,
    required this.city,
    required this.createdAt,
  });

  bool get isYoutube => url == null && vimeoUrl == null && youtubeUrl != null;

  Video copyWith({
    String? title,
    String? description,
    String? coverPhotoPortrait,
    User? postedBy,
    String? url,
    String? youtubeUrl,
    String? vimeoUrl,
    VideoCategories? category,
    List<String>? likes,
    List<String>? dislikes,
    String? country,
    String? city,
    Timestamp? createdAt,
  }) {
    return Video(
      docRef: docRef,
      title: title ?? this.title,
      description: description ?? this.description,
      coverPhotoPortrait: coverPhotoPortrait ?? this.coverPhotoPortrait,
      postedBy: postedBy ?? this.postedBy,
      url: url ?? this.url,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      vimeoUrl: vimeoUrl ?? this.vimeoUrl,
      category: category ?? this.category,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      country: country ?? this.country,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'coverPhotoPortrait': coverPhotoPortrait,
      'postedBy': FirebaseFirestore.instance
          .collection('users')
          .doc('users/${postedBy.email!}'),
      'url': url,
      'youtubeUrl': youtubeUrl,
      'vimeoUrl': vimeoUrl,
      'category': category.describe,
      'likes': likes,
      'dislikes': dislikes,
      'country': country,
      'city': city,
      'createdAt': createdAt,
    };
  }

  factory Video.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      {SnapshotOptions? options}) {
    final data = snapshot.data();

    return Video.fromMap(data!);
  }

  Map<String, dynamic> toFirestore() => toMap();

  factory Video.fromMap(Map<String, dynamic> map) {
    // final data = snapshot.data() ?? {};
    // map['postedBy'] =
    //     ((map['postedBy'] as DocumentReference<Map<String, dynamic>>).get());
    // .data();
    return Video(
      docRef: map['docRef'] as DocumentReference<Map<String, dynamic>>,
      title: map['title'] as String,
      description: map['description'] as String?,
      coverPhotoPortrait: map['coverphotoPortrait'] as String?,
      postedBy: User.fromFirestore(
        map['postedBy'] as DocumentSnapshot<Map<String, dynamic>>,
        null,
      ),
      url: map['url'] as String?,
      youtubeUrl:
          map['youtubeUrl'] != null ? map['youtubeUrl'] as String : null,
      vimeoUrl: map['vimeoUrl'] != null ? map['vimeoUrl'] as String : null,
      category: VideoCategories.fromString(map['category'] as String),
      likes: List<String>.from((map['likes'] as List<dynamic>)),
      dislikes: List<String>.from((map['dislikes'] as List<dynamic>)),
      country: map['country'] as String,
      city: map['city'] as String,
      createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Video.fromJson(String source) =>
      Video.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Video(title: $title, description: $description, coverPhotoPortrait: $coverPhotoPortrait, postedBy: $postedBy, url: $url, youtubeUrl: $youtubeUrl, vimeoUrl: $vimeoUrl, category: $category, likes: $likes, country: $country, city: $city, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Video other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.description == description &&
        other.coverPhotoPortrait == coverPhotoPortrait &&
        other.postedBy == postedBy &&
        other.url == url &&
        other.youtubeUrl == youtubeUrl &&
        other.vimeoUrl == vimeoUrl &&
        other.category == category &&
        // listEquals(other.likes, likes) &&
        // listEquals(other.dislikes, dislikes) &&
        // other.country == country &&
        // other.city == city &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        description.hashCode ^
        coverPhotoPortrait.hashCode ^
        postedBy.hashCode ^
        url.hashCode ^
        youtubeUrl.hashCode ^
        vimeoUrl.hashCode ^
        category.hashCode ^
        // likes.hashCode ^
        // dislikes.hashCode ^
        // country.hashCode ^
        // city.hashCode ^
        createdAt.hashCode;
  }
}
