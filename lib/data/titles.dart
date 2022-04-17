// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Titles {
  String name;
  String path;
  Titles({
    required this.name,
    required this.path,
  });

  Titles copyWith({
    String? name,
    String? path,
  }) {
    return Titles(
      name: name ?? this.name,
      path: path ?? this.path,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'path': path,
    };
  }

  factory Titles.fromMap(Map<String, dynamic> map) {
    return Titles(
      name: map['name'] as String,
      path: map['path'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Titles.fromJson(String source) => Titles.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Titles(name: $name, path: $path)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Titles &&
      other.name == name &&
      other.path == path;
  }

  @override
  int get hashCode => name.hashCode ^ path.hashCode;
}
