import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/contributions/data/models/contribution_model.dart';

class ContributionRepository {
  final Dio dio;

  ContributionRepository({required this.dio});

  Future<Map<String, String>> _authHeaders() async {
    final token = await UserPreferences().getBearerToken();
    return {'Authorization': 'Bearer $token', 'Accept': 'application/json'};
  }

  Future<DataState<ContributionModel>> contribute({
    required String eventId,
    required double amount,
    required String phone,
    required String network,
    String? message,
  }) async {
    try {
      final response = await dio.post(
        '$flockrAPIBaseUrl/events/$eventId/contribute',
        data: {
          'amount': amount,
          'phone': phone,
          'network': network,
          if (message != null && message.isNotEmpty) 'message': message,
        },
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess(ContributionModel.fromJson(
          response.data['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<EventContributionSummary>> getEventContributions(
      String eventId) async {
    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/events/$eventId/contributions',
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess(
          EventContributionSummary.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<List<ContributionModel>>> getMyContributions() async {
    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/contributions',
        options: Options(headers: await _authHeaders()),
      );
      final data = response.data['data'] as List? ?? response.data as List;
      return DataSuccess(data
          .map((e) => ContributionModel.fromJson(e as Map<String, dynamic>))
          .toList());
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
