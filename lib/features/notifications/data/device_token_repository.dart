import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';

class DeviceTokenRepository {
  final Dio dio;

  DeviceTokenRepository({required this.dio});

  Future<DataState<String>> registerToken(String token) async {
    final platform = Platform.isAndroid ? 'android' : 'ios';
    return _request(
      method: 'post',
      url: '$flockrAPIBaseUrl/devices/token',
      data: {'token': token, 'platform': platform},
    );
  }

  Future<DataState<String>> removeToken(String token) async {
    return _request(
      method: 'delete',
      url: '$flockrAPIBaseUrl/devices/token',
      data: {'token': token},
    );
  }

  Future<DataState<String>> announce({
    required String eventId,
    required String title,
    required String message,
  }) async {
    return _request(
      method: 'post',
      url: '$flockrAPIBaseUrl/events/$eventId/announce',
      data: {'title': title, 'message': message},
    );
  }

  Future<DataState<String>> _request({
    required String method,
    required String url,
    required Map<String, dynamic> data,
  }) async {
    final token = await UserPreferences().getBearerToken();
    final options = Options(headers: {
      'Authorization': 'Bearer $token',
      'Accept': acceptString,
    });

    try {
      final response = method == 'delete'
          ? await dio.delete(url, data: data, options: options)
          : await dio.post(url, data: data, options: options);

      if (response.statusCode == HttpStatus.ok) {
        final msg = response.data['message'] as String? ?? 'success';
        return DataSuccess(msg);
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
