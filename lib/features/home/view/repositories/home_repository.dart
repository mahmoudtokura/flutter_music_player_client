import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required File audioFile,
    required File imageFile,
    required String artist,
    required String songTitle,
    required String hexColor,
    required String token,
  }) async {
    try {
      var url = Uri.http(ServerConstants.serverURL, '/song/upload');
      var request = http.MultipartRequest("POST", url);
      request.fields.addAll({
        'artist': artist,
        'song_title': songTitle,
        'hex_code': hexColor,
      });
      request.files.addAll([
        await http.MultipartFile.fromPath(
          'song',
          audioFile.path,
        ),
        await http.MultipartFile.fromPath(
          'thumbnail',
          imageFile.path,
        ),
      ]);
      request.headers.addAll({
        'x-auth-token': token,
      });
      var response = await request.send();
      final res = await response.stream.bytesToString();
      if (response.statusCode == 201) {
        return Right(res);
      }
      log("HomeRepository: uploadSong: Error uploading song");
      return Left(AppFailure(res));
    } catch (e) {
      log("HomeRepository: uploadSong: $e");
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSongs({
    required String token,
  }) async {
    try {
      var url = Uri.http(ServerConstants.serverURL, '/song/list');
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      });
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as List;
        final songs = jsonResponse.map((e) => SongModel.fromMap(e)).toList();
        return Right(songs);
      } else {
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        log("HomeRepository: getAllSongs: Error getting all songs");
        return Left(AppFailure(jsonResponse['detail']));
      }
    } catch (e) {
      log("HomeRepository: getAllSongs: $e");
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> favASong({
    required String token,
    required String songId,
  }) async {
    try {
      var url = Uri.http(ServerConstants.serverURL, '/song/favorite');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(
          {
            'song_id': songId,
          },
        ),
      );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return Right(jsonResponse['message']);
      } else {
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        log("HomeRepository: getAllSongs: Error trying to favorite a song");
        return Left(AppFailure(jsonResponse['detail']));
      }
    } catch (e) {
      log("HomeRepository: favASong: $e");
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getFavoriteSongs({
    required String token,
  }) async {
    try {
      var url = Uri.http(ServerConstants.serverURL, '/song/list/favorites');
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      });
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as List;
        final songs =
            jsonResponse.map((res) => SongModel.fromMap(res['song'])).toList();
        return Right(songs);
      } else {
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        log("HomeRepository: getFavoriteSongs: Error getting favorite songs");
        return Left(AppFailure(jsonResponse['detail']));
      }
    } catch (e) {
      log("HomeRepository: getFavoriteSongs: $e");
      return Left(AppFailure(e.toString()));
    }
  }
}
