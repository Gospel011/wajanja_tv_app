import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:hive_flutter/hive_flutter.dart';
part 'user.g.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String? fullName;
  @HiveField(1)
  final String? email;
  @HiveField(2)
  final String? phone;
  @HiveField(3)
  final String? country;
  @HiveField(4)
  final String? photoURL;
  @HiveField(5)
  final bool emailVerified;
  // @HiveField(6)
  // late Timestamp createdAt;
  User({
    this.fullName,
    this.email,
    this.phone,
    this.country,
    this.photoURL,
    this.emailVerified = false,
    // Timestamp? createdAt,
  }) {
    // this.createdAt = createdAt ?? Timestamp.now();
  }

  String get initials =>
      (fullName ?? 'i').split(' ').map((el) => el[0].toUpperCase()).join('');

  factory User.fromCredential(firebase.UserCredential credential) {
    return User(
      email: credential.user?.email,
      fullName: credential.user?.displayName,
      photoURL: credential.user?.photoURL,
      emailVerified: credential.user?.emailVerified ?? false,
    );
  }

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    return User.fromMap(data!);
  }

  Map<String, dynamic> toFirestore() {
    return toMap()..removeWhere((key, value) => value == null);
  }

  User copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? country,
    String? photoURL,
    bool? emailVerified,
  }) {
    return User(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      photoURL: photoURL ?? this.photoURL,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'country': country,
      'photoURL': photoURL,
      'emailVerified': emailVerified,
      // 'createdAt': createdAt
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      fullName: map['fullName'] != null ? map['fullName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      photoURL: map['photoURL'] != null ? map['photoURL'] as String : null,
      emailVerified: (map['emailVerified'] ?? false) as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(fullName: $fullName, email: $email, phone: $phone, country: $country, photoURL: $photoURL, emailVerified: $emailVerified)';
  }
}
