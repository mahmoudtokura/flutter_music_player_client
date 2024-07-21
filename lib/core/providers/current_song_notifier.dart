import 'dart:developer';

import 'package:client/features/home/models/song_model.dart';
import 'package:client/features/home/view/repositories/home_local_repository.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? audioPlayer;
  bool isPlaying = false;

  late HomeLocalRepository _homeLocalRepository;
  @override
  SongModel? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  void updateSong(SongModel song) async {
    await audioPlayer?.stop();
    audioPlayer = AudioPlayer();
    try {
      await audioPlayer!.setAudioSource(
        AudioSource.uri(
          Uri.parse(
            song.song_url,
          ),
          tag: MediaItem(
            id: song.id.toString(),
            artist: song.artist,
            title: song.song_title,
            artUri: Uri.parse(song.thumbnail_url),
          ),
        ),
      );
      audioPlayer!.playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          audioPlayer!.seek(Duration.zero);
          audioPlayer!.pause();
          isPlaying = false;
          state = state?.copyWith(hex_code: state?.hex_code);
        }
      });
      _homeLocalRepository.uploadLocalSongs(song);
      audioPlayer!.play();
      isPlaying = true;
    } on PlayerException catch (e) {
      log("Error loading audio source: $e");
    }
    state = song;
  }

  void playPause() {
    if (isPlaying == true) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }
    isPlaying = !isPlaying;
    state = state?.copyWith(hex_code: state?.hex_code);
  }

  void seek(double duration) {
    audioPlayer?.seek(
      Duration(
          milliseconds:
              (duration * audioPlayer!.duration!.inMilliseconds).toInt()),
    );
  }
}
