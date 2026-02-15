/* import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
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
        UserPreferences().setBearerToken(loginResponse.accessToken);
        UserPreferences().setUserName(loginResponse.user.name);
        UserPreferences().setUserId(loginResponse.user.uuid);
        UserPreferences().setLoginStatus(true);
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

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
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

      debugPrint('Login status: ${response.statusCode}');
      debugPrint('Login API Response: ${response.data}');

      if (response.statusCode == HttpStatus.ok) {
        final loginResponse = LoginResponse.fromJson(response.data);

        await UserPreferences().setBearerToken(loginResponse.accessToken);
        await UserPreferences().setUserName(loginResponse.user.name);
        await UserPreferences().setUserId(loginResponse.user.uuid);
        await UserPreferences().setLoginStatus(true);

        return DataSuccess(loginResponse);
      }

      // If server returns non-200 without throwing (rare)
      String errorMessage = "Login failed";
      final data = response.data;
      if (data is Map<String, dynamic>) {
        // Try common patterns
        if (data["message"] != null) {
          errorMessage = data["message"].toString();
        } else if (data["error"] is String) {
          errorMessage = data["error"].toString();
        } else if (data["error"] is Map<String, dynamic>) {
          final err = data["error"] as Map<String, dynamic>;
          if (err.isNotEmpty) {
            final first = err.values.first;
            if (first is List && first.isNotEmpty) {
              errorMessage = first.first.toString();
            } else if (first != null) {
              errorMessage = first.toString();
            }
          }
        }
      }

      return DataFailed(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: errorMessage,
        ),
      );
    } on DioException catch (e) {
      // ✅ This catches 401/422 etc.
      debugPrint('Login DioException status: ${e.response?.statusCode}');
      debugPrint('Login DioException data: ${e.response?.data}');

      String errorMessage = "Login failed";

      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        // Try common patterns
        if (data["message"] != null) {
          errorMessage = data["message"].toString();
        } else if (data["error"] is String) {
          errorMessage = data["error"].toString();
        } else if (data["error"] is Map<String, dynamic>) {
          final err = data["error"] as Map<String, dynamic>;
          if (err.isNotEmpty) {
            final first = err.values.first;
            if (first is List && first.isNotEmpty) {
              errorMessage = first.first.toString();
            } else if (first != null) {
              errorMessage = first.toString();
            }
          }
        }
      }

      return DataFailed(
        DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          type: e.type,
          error: errorMessage, // ✅ clean message
        ),
      );
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: '$flockrAPIBaseUrl/login'),
          type: DioExceptionType.unknown,
          error: e.toString(),
        ),
      );
    }
  }
}