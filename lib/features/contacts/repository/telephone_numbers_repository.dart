import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';

abstract class TelephoneNumbersRepository {
  Future<DataState<List<dynamic>>> getNumbers();
}

class TelephoneNumbersRepositoryImpl implements TelephoneNumbersRepository {
  final Dio _dio;

  TelephoneNumbersRepositoryImpl(this._dio);

  @override
  Future<DataState<List<dynamic>>> getNumbers() async {
    String bearerToken = await UserPreferences().getBearerToken();
    try {
      final response = await _dio.get(
        '$flockrAPIBaseUrl/all-phone-numbers',
        options: Options(
          headers: {
            'Authorization': "Bearer " + bearerToken,
            'Accept': acceptString,
          },
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> data = response.data['data'];

        return DataSuccess(data);
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
