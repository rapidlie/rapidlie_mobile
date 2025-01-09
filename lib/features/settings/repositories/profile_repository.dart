import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/user/models/user_model.dart';

class ProfileRepository {
  final Dio dio;

  ProfileRepository({required this.dio});

  Future<DataState<void>> getUserProfile() async {
    String bearerToken = await UserPreferences().getBearerToken();

    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/user',
        options: Options(
          headers: {
            'Authorization': "Bearer " + bearerToken,
            'Accept': acceptString,
          },
        ),
      );
      if (response.statusCode == HttpStatus.ok) {
        final user = UserModel.fromJson(response.data['data']);

        await UserPreferences().saveUser(user);

        return DataSuccess(user);
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
