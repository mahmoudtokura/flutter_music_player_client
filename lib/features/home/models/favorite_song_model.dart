// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FavoriteSongModel {
  final String id;
  final String song_id;
  final String user_id;
  final String added;

  FavoriteSongModel({
    required this.id,
    required this.song_id,
    required this.user_id,
    required this.added,
  });

  FavoriteSongModel copyWith({
    String? id,
    String? song_id,
    String? user_id,
    String? added,
  }) {
    return FavoriteSongModel(
      id: id ?? this.id,
      song_id: song_id ?? this.song_id,
      user_id: user_id ?? this.user_id,
      added: added ?? this.added,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'song_id': song_id,
      'user_id': user_id,
      'added': added,
    };
  }

  factory FavoriteSongModel.fromMap(Map<String, dynamic> map) {
    return FavoriteSongModel(
      id: map['id'] ?? "",
      song_id: map['song_id'] ?? "",
      user_id: map['user_id'] ?? "",
      added: map['added'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory FavoriteSongModel.fromJson(String source) =>
      FavoriteSongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FavoriteSongModel(id: $id, song_id: $song_id, user_id: $user_id, added: $added)';
  }

  @override
  bool operator ==(covariant FavoriteSongModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.song_id == song_id &&
        other.user_id == user_id &&
        other.added == added;
  }

  @override
  int get hashCode {
    return id.hashCode ^ song_id.hashCode ^ user_id.hashCode ^ added.hashCode;
  }
}
