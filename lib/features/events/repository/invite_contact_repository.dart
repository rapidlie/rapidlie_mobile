import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';

class InviteContactRepository {
  final Dio dio;

  InviteContactRepository({required this.dio});

  Future<DataState<void>> inviteContact(
      {required List<String> guests, required String id}) async {
    try {
      final response = await dio.post(
        '$flockrAPIBaseUrl/events/$id/send-invitation',
        data: {
          'guests': guests,
        },
        options: Options(
          headers: {
            'Authorization': "Bearer " + UserPreferences().getBearerToken(),
            'Accept': acceptString,
          },
        ),
      );

      if (response.statusCode == 201) {
        return DataSuccess(response.data);
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
