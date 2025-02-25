// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/// This is a custom class for packaging the files for multi-part request
class File extends Object {
  /// This is the name of the file field that the backend would use in
  /// identifying which file is which.
  final String name;

  /// This is the location of the file in the internal storage
  final String path;

  const File({required this.name, required this.path});

  @override
  String toString() {
    return 'File(name: $name, path: $path)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'path': path,
    };
  }

  factory File.fromMap(Map<String, dynamic> map) {
    return File(
      name: map['name'] as String,
      path: map['path'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory File.fromJson(String source) =>
      File.fromMap(json.decode(source) as Map<String, dynamic>);

  File copyWith({
    String? name,
    String? path,
  }) {
    return File(
      name: name ?? this.name,
      path: path ?? this.path,
    );
  }

  @override
  bool operator ==(covariant Object other) {
    if (identical(this, other)) return true;

    if (other is! File) return false;

    return other.path == path;
  }

  @override
  int get hashCode => path.hashCode;
}
