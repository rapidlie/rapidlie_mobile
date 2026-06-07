import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/polls/data/models/poll_model.dart';

class PollRepository {
  final Dio dio;

  PollRepository({required this.dio});

  Future<Map<String, String>> _authHeaders() async {
    final token = await UserPreferences().getBearerToken();
    return {'Authorization': 'Bearer $token', 'Accept': 'application/json'};
  }

  Future<DataState<List<PollModel>>> getPolls(String eventId) async {
    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/events/$eventId/polls',
        options: Options(headers: await _authHeaders()),
      );
      final data = response.data['data'] as List? ?? response.data as List;
      return DataSuccess(data
          .map((e) => PollModel.fromJson(e as Map<String, dynamic>))
          .toList());
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<PollModel>> createPoll({
    required String eventId,
    required String question,
    required String type,
    required List<String> options,
    String? endsAt,
  }) async {
    try {
      final response = await dio.post(
        '$flockrAPIBaseUrl/events/$eventId/polls',
        data: {
          'question': question,
          'type': type,
          'options': options,
          if (endsAt != null) 'ends_at': endsAt,
        },
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess(
          PollModel.fromJson(response.data['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<PollModel>> vote({
    required String pollId,
    required List<String> optionIds,
  }) async {
    try {
      final response = await dio.post(
        '$flockrAPIBaseUrl/polls/$pollId/vote',
        data: {'option_ids': optionIds},
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess(
          PollModel.fromJson(response.data['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<String>> deletePoll(String pollId) async {
    try {
      await dio.delete(
        '$flockrAPIBaseUrl/polls/$pollId',
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess('Poll deleted.');
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
