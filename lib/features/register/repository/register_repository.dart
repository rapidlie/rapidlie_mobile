import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/register/models/register_model.dart';

class RegisterRepository {
  final Dio dio;

  RegisterRepository({required this.dio});

  Future<DataState<RegisterResponse>> registerUser({
    required String name,
    required String email,
    required String password,
    String? phone,
    required String countryCode,
    required String profileImage,
  }) async {
    try {
      final response = await dio.post(
        '$flockrAPIBaseUrl/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'country_code': countryCode,
          'profile_image': profileImage,
        },
        options: Options(
          headers: {
            'Accept': acceptString,
          },
        ),
      );

      debugPrint('Register status: ${response.statusCode}');
      debugPrint('Register API Response: ${response.data}');

      if (response.statusCode == 201) {
        final registerResponse = RegisterResponse.fromJson(response.data);

        await UserPreferences().setLoginStatus(true);
        await UserPreferences().setUserEmail(registerResponse.user.email);
        await UserPreferences().setUserId(registerResponse.user.uuid);
        await UserPreferences().setRegistrationStep("partial");
        await UserPreferences().setProfileImage(registerResponse.user.avatar);

        return DataSuccess(registerResponse);
      }

      String errorMessage = "Registration failed";
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final err = data["error"];
        if (err is Map<String, dynamic> && err.isNotEmpty) {
          final firstFieldErrors = err.values.first;
          if (firstFieldErrors is List && firstFieldErrors.isNotEmpty) {
            errorMessage = firstFieldErrors.first.toString();
          }
        } else if (data["message"] != null) {
          errorMessage = data["message"].toString();
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
      debugPrint('Register DioException status: ${e.response?.statusCode}');
      debugPrint('Register DioException data: ${e.response?.data}');

      String errorMessage = "Registration failed";

      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final err = data["error"];
        if (err is Map<String, dynamic> && err.isNotEmpty) {
          // { error: { email: ["The email has already been taken."] } }
          final firstFieldErrors = err.values.first;
          if (firstFieldErrors is List && firstFieldErrors.isNotEmpty) {
            errorMessage = firstFieldErrors.first.toString();
          } else if (firstFieldErrors != null) {
            errorMessage = firstFieldErrors.toString();
          }
        } else if (data["message"] != null) {
          errorMessage = data["message"].toString();
        }
      }

      return DataFailed(
        DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          type: e.type,
          error: errorMessage, 
        ),
      );
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: '$flockrAPIBaseUrl/register'),
          type: DioExceptionType.unknown,
          error: e.toString(),
        ),
      );
    }
  }
}