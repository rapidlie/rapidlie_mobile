import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/lens/data/models/lens_model.dart';

class LensRepository {
  final Dio dio;
  LensRepository({required this.dio});

  Future<DataState<LensModel>> getInsights(String eventId) async {
    try {
      final token = await UserPreferences().getBearerToken();
      final response = await dio.get(
        '$flockrAPIBaseUrl/events/$eventId/insights',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }),
      );
      return DataSuccess(
          LensModel.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
