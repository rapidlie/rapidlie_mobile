import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/events/models/event_model.dart';

abstract class EventRepository {
  Future<DataState<List<EventDataModel>>> getEventEntries();
}

class EventRepositoryImpl implements EventRepository {
  final Dio _dio;

  EventRepositoryImpl(this._dio);

  @override
  Future<DataState<List<EventDataModel>>> getEventEntries() async {
    String bearerToken = await UserPreferences().getBearerToken();
    try {
      final response = await _dio.get(
        '$flockrAPIBaseUrl/events/public',
        options: Options(
          headers: {
            'Authorization': "Bearer " + bearerToken,
            'Accept': acceptString,
          },
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        final eventResponse = EventResponseModel.fromJson(response.data);

        final List<EventDataModel> events = eventResponse.data;
        return DataSuccess(events);
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
