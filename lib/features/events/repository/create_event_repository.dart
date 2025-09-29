import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';

class CreateEventRepository {
  final Dio dio;

  CreateEventRepository({required this.dio});

  Future<DataState<void>> createEvent({
    required String image,
    required String name,
    required String eventType,
    required String category,
    required String description,
    required String date,
    required String startTime,
    required String endTime,
    required String venue,
    required String mapLocation,
    List<String>? guests,
  }) async {
    print("Entry level");
    try {
      print("Entered ty to create event");
      final response = await dio.post(
        '$flockrAPIBaseUrl/events',
        data: {
          'image': image,
          'name': name,
          'event_type': eventType,
          'category': category,
          'description': description,
          'date': date,
          'start_time': startTime,
          'end_time': endTime,
          'venue': venue,
          'map_location': mapLocation,
          'guests': guests,
        },
        options: Options(
          headers: {
            'Authorization': "Bearer " + UserPreferences().getBearerToken(),
            'Accept': acceptString,
          },
        ),
      );
      print("Exited to create event");
      if (response.statusCode == HttpStatus.created) {
        print("Create event successful");
        return DataSuccess(response.data);
      } else {
        print(response.statusMessage);
        return DataFailed(DioException(
          error: response.statusMessage,
          response: response,
          type: DioExceptionType.badResponse,
          requestOptions: response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      print(e.message);
      return DataFailed(e);
    }
  }
}
