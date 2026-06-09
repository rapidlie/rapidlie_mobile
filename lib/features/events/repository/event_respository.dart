import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/events/models/event_model.dart';

abstract class EventRepository {
  //Future<DataState<List<EventDataModel>>> getAllEvents();
  Future<DataState<List<EventDataModel>>> getPrivateEvents();
  Future<DataState<List<EventDataModel>>> getInvitedEvents();
  Future<DataState<List<EventDataModel>>> getPublicEvents();
  Future<DataState<List<EventDataModel>>> getUpcomingEvents();
  Future<DataState<List<EventDataModel>>> getEventsByCategory(
      String categoryId);
}

class EventRepositoryImpl implements EventRepository {
  final Dio dio;

  EventRepositoryImpl(this.dio);

  @override
  Future<DataState<List<EventDataModel>>> getPrivateEvents() async {
    return _getEvents('$flockrAPIBaseUrl/events/private');
  }

  @override
  Future<DataState<List<EventDataModel>>> getPublicEvents() async {
    return _getEvents('$flockrAPIBaseUrl/events/public');
  }

  @override
  Future<DataState<List<EventDataModel>>> getInvitedEvents() {
    return _getEvents('$flockrAPIBaseUrl/events/invited');
  }

  @override
  Future<DataState<List<EventDataModel>>> getUpcomingEvents() async {
    return _getEvents('$flockrAPIBaseUrl/events/upcoming');
  }

  @override
  Future<DataState<List<EventDataModel>>> getEventsByCategory(
      String categoryId) async {
    return _getEvents('$flockrAPIBaseUrl/events/category/$categoryId');
  }

  Future<DataState<List<EventDataModel>>> _getEvents(String url) async {
    String bearerToken = await UserPreferences().getBearerToken();

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': "Bearer $bearerToken",
            'Accept': acceptString,
          },
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        final data = response.data;
        final Map<String, dynamic> jsonMap = data is String
            ? Map<String, dynamic>.from(jsonDecode(data) as Map)
            : Map<String, dynamic>.from(data as Map);

        final eventResponse = EventResponseModel.fromJson(jsonMap);
        return DataSuccess(eventResponse.data);
      } else {
        return DataFailed(DioException(
          error: response.statusMessage,
          response: response,
          type: DioExceptionType.badResponse,
          requestOptions: response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      debugPrint('[EventRepo] DioException $url: ${e.message} ${e.response?.statusCode}');
      return DataFailed(e);
    } catch (e, stack) {
      debugPrint('[EventRepo] Parse error $url: $e\n$stack');
      return DataFailed(DioException(
        error: e.toString(),
        type: DioExceptionType.unknown,
        requestOptions: RequestOptions(path: url),
      ));
    }
  }
}
