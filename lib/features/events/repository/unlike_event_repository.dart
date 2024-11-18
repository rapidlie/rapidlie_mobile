import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';

class UnlikeEventRepository {
  final Dio dio;

  UnlikeEventRepository({required this.dio});

  Future<DataState<String>> unlikeEvent(String eventId) async {
    String bearerToken = await UserPreferences().getBearerToken();

    try {
      final response = await dio.post(
        '$flockrAPIBaseUrl/events/$eventId/unlike',
        options: Options(
          headers: {
            'Authorization': "Bearer " + bearerToken,
            'Accept': acceptString,
          },
        ),
        data: {},
      );

      if (response.statusCode == HttpStatus.ok) {
        print("Event Unliked");
        return DataSuccess("success");
      } else {
        return DataFailed(
          DioException(
            error: response.statusMessage,
            response: response,
            type: DioExceptionType.badResponse,
            requestOptions: response.requestOptions,
          ),
        );
      }
    } on DioException catch (e) {
      print("Event Unliked Failed");
      print(e);
      return DataFailed(e);
    }
  }
}
