import 'dart:io';
import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';

class ConsentRepository {
  final Dio dio;

  ConsentRepository({required this.dio});

  Future<DataState<String>> giveConsent(
      {required String status, required String eventId}) async {
    String bearerToken = await UserPreferences().getBearerToken();

    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/events/invitations/consent?status=$status&event=$eventId',
        options: Options(
          headers: {
            'Authorization': "Bearer " + bearerToken,
            'Accept': acceptString,
          },
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        final request = response.statusMessage!.toString();

        return DataSuccess(request);
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
