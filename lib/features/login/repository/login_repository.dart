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
