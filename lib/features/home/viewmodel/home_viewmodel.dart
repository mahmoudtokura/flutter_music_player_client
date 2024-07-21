import 'dart:developer';
import 'dart:io';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/models/favorite_song_model.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:client/features/home/view/repositories/home_local_repository.dart';
import 'package:client/features/home/view/repositories/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(GetAllSongsRef ref) async {
  final homeRepository = ref.watch(homeRepositoryProvider);
  final res = await homeRepository.getAllSongs(
    token: ref.watch(currentUserNotifierProvider.select((user) => user!.token)),
  );
  final val = switch (res) {
    Right(value: final r) => r,
    Left(value: final l) => throw l.message,
  };

  return val;
}

@riverpod
Future<List<SongModel>> getAllFavoriteSongs(GetAllFavoriteSongsRef ref) async {
  final homeRepository = ref.watch(homeRepositoryProvider);
  final res = await homeRepository.getFavoriteSongs(
    token: ref.watch(currentUserNotifierProvider.select((user) => user!.token)),
  );
  final val = switch (res) {
    Right(value: final r) => r,
    Left(value: final l) => throw l.message,
  };

  return val;
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;
  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File audioFile,
    required File imageFile,
    required String artist,
    required String songTitle,
    required Color hexColor,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.uploadSong(
      audioFile: audioFile,
      imageFile: imageFile,
      artist: artist,
      songTitle: songTitle,
      hexColor: rgbToHex(hexColor),
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Right(value: final r) => state = AsyncValue.data(r),
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
    };
    log(val.toString());
  }

  List<SongModel> getRecentlyPlayedSongs() {
    return _homeLocalRepository.loadSongs();
  }

  Future<void> favASong({required String songId}) async {
    final res = await _homeRepository.favASong(
      songId: songId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Right(value: final r) => _favoriteASong(r, songId),
      Left(value: final l) => state = AsyncValue.error(l, StackTrace.current),
    };

    log(val.toString());
  }

  AsyncValue _favoriteASong(bool isFavorite, String songId) {
    final userNotifier = ref.read(currentUserNotifierProvider.notifier);
    if (isFavorite) {
      userNotifier.setUser(ref.read(currentUserNotifierProvider)!.copyWith(
        favorites: [
          ...ref.read(currentUserNotifierProvider)!.favorites,
          FavoriteSongModel(
            id: "",
            song_id: songId,
            user_id: "",
            added: DateTime.now().toString(),
          )
        ],
      ));
    } else {
      userNotifier.setUser(ref.read(currentUserNotifierProvider)!.copyWith(
        favorites: [
          ...ref
              .read(currentUserNotifierProvider)!
              .favorites
              .where((fav) => fav.song_id != songId)
        ],
      ));
    }
    ref.invalidate(getAllFavoriteSongsProvider);
    return state = AsyncValue.data(isFavorite);
  }
}
