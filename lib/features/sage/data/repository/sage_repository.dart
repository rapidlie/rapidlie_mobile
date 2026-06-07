import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/sage/data/models/sage_model.dart';

class SageRepository {
  final Dio dio;
  SageRepository({required this.dio});

  Future<DataState<SageSuggestions>> getSuggestions({
    required String eventId,
    String? question,
  }) async {
    try {
      final token = await UserPreferences().getBearerToken();
      final response = await dio.post(
        '$flockrAPIBaseUrl/events/$eventId/sage/suggest',
        data: {
          if (question != null && question.isNotEmpty) 'question': question,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }),
      );
      return DataSuccess(
          SageSuggestions.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
