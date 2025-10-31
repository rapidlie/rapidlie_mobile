import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/home/models/notification.dart';

class NotificationsRepository {
  final Dio dio;

  NotificationsRepository({required this.dio});

  Future<DataState<List<Notifications>>> getNotifications() async {
    String bearerToken = await UserPreferences().getBearerToken();
    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/upcoming-features',
        options: Options(
          headers: {
            'Authorization': "Bearer " + bearerToken,
            'Accept': acceptString,
          },
        ),
      );
      if (response.statusCode == HttpStatus.ok) {
        List<dynamic> data = response.data;
        List<Notifications> notifications =
            data.map((item) => Notifications.fromJson(item)).toList();
        return DataSuccess(notifications);
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
