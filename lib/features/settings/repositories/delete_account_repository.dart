import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';

class DeleteAccountRepository {
  final Dio dio;

  DeleteAccountRepository({required this.dio});

  Future<DataState<void>> deleteAccount({
    required String email,
  }) async {
    try {
      final response = await dio.delete(
        '$flockrAPIBaseUrl/delete/user',
        data: {
          'email': email,
        },
        options: Options(
          headers: {
            'Accept': acceptString,
            'Authorization': "Bearer " + UserPreferences().getBearerToken(),
          },
        ),
      );

      if (response.statusCode == HttpStatus.noContent) {
        return DataSuccess(response.statusMessage);
      } else {
        return DataFailed(DioException(
          error: response.statusMessage,
          response: response,
          type: DioExceptionType.badResponse,
          requestOptions: response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}

/* 
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/features/login/models/login_model.dart';

class LoginRepository {
  final Dio dio;

  LoginRepository({required this.dio});

  Future<DataState<LoginResponse>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '$flockrAPIBaseUrl/login',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Accept': acceptString,
          },
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        final loginResponse = LoginResponse.fromJson(response.data);
        return DataSuccess(loginResponse);
      } else {
        return DataFailed(DioException(
          error: response.statusMessage,
          response: response,
          type: DioExceptionType.badResponse,
          requestOptions: response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}


 */