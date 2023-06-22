// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  final String authorId;
  String? id;
  final String content;
  String coverLink;
  final bool isGlobal;
  final String title;
  Story({
    required this.authorId,
    this.id,
    required this.content,
    required this.coverLink,
    required this.isGlobal,
    required this.title,
  });

  factory Story.fromQueryDocumentSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return Story(
      authorId: doc['authorId'], 
      id: doc.id, 
      content: doc['content'], 
      coverLink: doc['coverLink'] ?? 'https://firebasestorage.googleapis.com/v0/b/reading-book-1aa02.appspot.com/o/img_holder.jpg?alt=media&token=3bae214a-601f-4b82-8ee4-71189ceb55c1', 
      isGlobal: doc['isGlobal'], 
      title: doc['title']);
  }

  Story copyWith({
    String? authorId,
    String? id,
    String? content,
    String? coverLink,
    bool? isGlobal,
    String? title,
  }) {
    return Story(
      authorId: authorId ?? this.authorId,
      id: id ?? this.id,
      content: content ?? this.content,
      coverLink: coverLink ?? this.coverLink,
      isGlobal: isGlobal ?? this.isGlobal,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'authorId': authorId,
      'id': id,
      'content': content,
      'coverLink': coverLink,
      'isGlobal': isGlobal,
      'title': title,
    };
  }

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      authorId: map['authorId'] as String,
      id: map['id'] as String,
      content: map['content'] as String,
      coverLink: map['coverLink'] as String,
      isGlobal: map['isGlobal'] as bool,
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Story.fromJson(String source) => Story.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Story(authorId: $authorId, id: $id, content: $content, coverLink: $coverLink, isGlobal: $isGlobal, title: $title)';
  }

  @override
  bool operator ==(covariant Story other) {
    if (identical(this, other)) return true;
  
    return 
      other.authorId == authorId &&
      other.id == id &&
      other.content == content &&
      other.coverLink == coverLink &&
      other.isGlobal == isGlobal &&
      other.title == title;
  }

  @override
  int get hashCode {
    return authorId.hashCode ^
      id.hashCode ^
      content.hashCode ^
      coverLink.hashCode ^
      isGlobal.hashCode ^
      title.hashCode;
  }
}
