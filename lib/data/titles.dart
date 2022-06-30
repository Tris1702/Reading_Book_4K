// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Titles {
  final String id;
  final String title;
  final String thumb;
  final int isFav;
  Titles({
    required this.id,
    required this.title,
    required this.thumb,
    required this.isFav,
  });
  

  Titles copyWith({
    String? id,
    String? title,
    String? thumb,
    int? isFav,
  }) {
    return Titles(
      id: id ?? this.id,
      title: title ?? this.title,
      thumb: thumb ?? this.thumb,
      isFav: isFav ?? this.isFav,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'thumb': thumb,
      'isFav': isFav,
    };
  }

   factory Titles.fromMap(Map<String, dynamic> map) {
    return Titles(
      id: map['id'] as String,
      title: map['title'] as String,
      thumb: map['thumb'] as String,
      isFav: map['isFav'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Titles.fromJson(String source) => Titles.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Titles(id: $id, title: $title, thumb: $thumb, isFav: $isFav)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Titles &&
      other.id == id &&
      other.title == title &&
      other.thumb == thumb &&
      other.isFav == isFav;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      thumb.hashCode ^
      isFav.hashCode;
  }
}
