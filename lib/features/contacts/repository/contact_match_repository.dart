import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/contacts/models/matched_user_model.dart';

class ContactMatchRepository {
  final Dio _dio;
  ContactMatchRepository({required Dio dio}) : _dio = dio;

  Future<DataState<List<MatchedUserModel>>> matchContacts(
      List<String> phoneNumbers) async {
    final bearerToken = await UserPreferences().getBearerToken();
    try {
      final response = await _dio.post(
        '$flockrAPIBaseUrl/contacts/match',
        data: {'phone_numbers': phoneNumbers},
        options: Options(
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Accept': acceptString,
          },
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> raw = response.data['data'] ?? [];
        final users =
            raw.map((e) => MatchedUserModel.fromJson(e)).toList();
        return DataSuccess(users);
      }

      return DataFailed(DioException(
        error: response.statusMessage,
        response: response,
        type: DioExceptionType.badResponse,
        requestOptions: response.requestOptions,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
