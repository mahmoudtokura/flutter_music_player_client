import 'dart:convert';
import 'dart:developer';

import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/core/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      var url = Uri.http(ServerConstants.serverURL, '/auth/signup');
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );
      var respBodyMap = jsonDecode(response.body);
      if (response.statusCode != 201) {
        return Left(AppFailure(respBodyMap['detail']));
      }
      return Right(UserModel.fromMap(respBodyMap));
    } catch (e) {
      log("AuthRemoteRepository.signup: $e");
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      var url = Uri.http(ServerConstants.serverURL, '/auth/login');
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      var respBodyMap = jsonDecode(response.body);
      if (response.statusCode != 200) {
        return Left(AppFailure(respBodyMap['detail']));
      }
      return Right(UserModel.fromMap(respBodyMap));
    } catch (e) {
      log("AuthRemoteRepository.login: $e");
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUserData(
    String token,
  ) async {
    try {
      var url = Uri.http(ServerConstants.serverURL, '/auth/');
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      var respBodyMap = jsonDecode(response.body);
      if (response.statusCode != 200) {
        return Left(AppFailure(respBodyMap['detail']));
      }
      return Right(UserModel.fromMap(respBodyMap).copyWith(token: token));
    } catch (e) {
      log("AuthRemoteRepository.login: $e");
      return Left(AppFailure(e.toString()));
    }
  }
}
