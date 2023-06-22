// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:reading_book_4k/base/utilitize.dart';


class Author {
  final String userId;
  String name;
  final String email;
  String avatarLink;
  final List<String> favStoryIds;

  factory Author.fromQueryDocumentSnapshot(QueryDocumentSnapshot doc) {
    return Author(
      userId: doc['userId'], 
      name: doc['name'], 
      email: doc['email'], 
      avatarLink: doc['avatarLink'] ?? 'https://firebasestorage.googleapis.com/v0/b/reading-book-1aa02.appspot.com/o/img_holder.jpg?alt=media&token=3bae214a-601f-4b82-8ee4-71189ceb55c1',
      favStoryIds: Utilitize.convertListDynamicToStringList(doc['favStoryIds'])
    );
  }

  Author({
    required this.userId,
    required this.name,
    required this.email,
    required this.avatarLink,
    required this.favStoryIds,
  });

  Author copyWith({
    String? id,
    String? userId,
    String? name,
    String? email,
    String? avatarLink,
    List<String>? favStoryIds,
  }) {
    return Author(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarLink: avatarLink ?? this.avatarLink,
      favStoryIds: favStoryIds ?? this.favStoryIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'email': email,
      'avatarLink': avatarLink,
      'favStoryIds': favStoryIds,
    };
  }

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      userId: map['userId'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      avatarLink: map['avatarLink'] as String,
      favStoryIds: List<String>.from((map['favStoryIds'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Author.fromJson(String source) => Author.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Author(userId: $userId, name: $name, email: $email, avatarLink: $avatarLink, favStoryIds: $favStoryIds)';
  }

  @override
  bool operator ==(covariant Author other) {
    if (identical(this, other)) return true;
  
    return 
      other.userId == userId &&
      other.name == name &&
      other.email == email &&
      other.avatarLink == avatarLink &&
      listEquals(other.favStoryIds, favStoryIds);
  }

  @override
  int get hashCode {
    return
      userId.hashCode ^
      name.hashCode ^
      email.hashCode ^
      avatarLink.hashCode ^
      favStoryIds.hashCode;
  }
}
