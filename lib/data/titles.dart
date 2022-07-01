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
  
   factory Titles.fromMap(Map<String, dynamic> map) {
    return Titles(
      id: map['id'] as String,
      title: map['title'] as String,
      thumb: map['thumb'] as String,
      isFav: map['isFav'] as int,
    );
  }

  factory Titles.fromJson(String source) => Titles.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Titles(id: $id, title: $title, thumb: $thumb, isFav: $isFav)';
  }
}
