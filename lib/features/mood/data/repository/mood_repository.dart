import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/features/mood/data/models/mood_model.dart';

class MoodRepository {
  final Dio dio;
  MoodRepository({required this.dio});

  Future<Map<String, String>> _authHeaders() async {
    final token = await UserPreferences().getBearerToken();
    return {'Authorization': 'Bearer $token', 'Accept': 'application/json'};
  }

  Future<DataState<List<MoodOption>>> getMoods() async {
    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/moods',
        options: Options(headers: await _authHeaders()),
      );
      final list = (response.data['moods'] as List)
          .map((e) => MoodOption.fromJson(e as Map<String, dynamic>))
          .toList();
      return DataSuccess(list);
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<String>> getCurrentMood() async {
    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/mood',
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess(response.data['mood'] as String? ?? '');
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<String>> setMood(String mood) async {
    try {
      final response = await dio.post(
        '$flockrAPIBaseUrl/mood',
        data: {'mood': mood},
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess(response.data['mood'] as String);
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<List<EventDataModel>>> getMoodSuggestions() async {
    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/mood/suggestions',
        options: Options(headers: await _authHeaders()),
      );
      final list = (response.data['data'] as List)
          .map((e) => EventDataModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return DataSuccess(list);
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
