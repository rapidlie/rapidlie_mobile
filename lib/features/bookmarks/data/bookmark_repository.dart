import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/events/models/event_model.dart';

class BookmarkRepository {
  final Dio dio;

  BookmarkRepository({required this.dio});

  Future<DataState<String>> bookmarkEvent(String eventId) async {
    return _post('$flockrAPIBaseUrl/events/$eventId/bookmark');
  }

  Future<DataState<String>> removeBookmark(String eventId) async {
    return _delete('$flockrAPIBaseUrl/events/$eventId/bookmark');
  }

  Future<DataState<List<EventDataModel>>> getBookmarkedEvents() async {
    final token = await UserPreferences().getBearerToken();
    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/all-bookmark-events',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': acceptString,
        }),
      );
      if (response.statusCode == HttpStatus.ok) {
        final events = EventResponseModel.fromJson(response.data).data;
        return DataSuccess(events);
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

  Future<DataState<String>> _post(String url) async {
    final token = await UserPreferences().getBearerToken();
    try {
      final response = await dio.post(
        url,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': acceptString,
        }),
        data: {},
      );
      if (response.statusCode == HttpStatus.ok) return DataSuccess('success');
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

  Future<DataState<String>> _delete(String url) async {
    final token = await UserPreferences().getBearerToken();
    try {
      final response = await dio.delete(
        url,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': acceptString,
        }),
      );
      if (response.statusCode == HttpStatus.ok) return DataSuccess('success');
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
