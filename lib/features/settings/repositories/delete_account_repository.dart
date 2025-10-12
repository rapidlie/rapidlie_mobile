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

      if (response.statusCode == 200) {
        UserPreferences().clearAll();
        return DataSuccess(null);
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
