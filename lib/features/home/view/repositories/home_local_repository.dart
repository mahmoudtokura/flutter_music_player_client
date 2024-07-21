import 'package:client/features/home/models/song_model.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(HomeLocalRepositoryRef ref) {
  return HomeLocalRepository();
}

class HomeLocalRepository {
  final Box box = Hive.box();

  void uploadLocalSongs(SongModel song) {
    box.put(song.id, song.toJson());
  }

  List<SongModel> loadSongs() {
    final List<SongModel> songs = [];
    for (var i = 0; i < box.length; i++) {
      final song = SongModel.fromJson(box.getAt(i));
      songs.add(song);
    }
    return songs;
  }
}
