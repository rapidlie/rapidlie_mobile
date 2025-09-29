import 'dart:io';
import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/events/models/event_model.dart';

class EventDetailRepository {
  final Dio dio;
  EventDetailRepository(this.dio);

  Future<DataState<EventDataModel>> getEventsById(String eventId) async {
    return _getEvents('$flockrAPIBaseUrl/events/$eventId');
  }

  Future<DataState<EventDataModel>> _getEvents(String url) async {
    String bearerToken = await UserPreferences().getBearerToken();

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': "Bearer " + bearerToken,
            'Accept': acceptString,
          },
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        final eventResponse = EventDataModel.fromJson(response.data['data']);

        return DataSuccess(eventResponse);
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
