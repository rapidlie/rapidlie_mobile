import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/reels/data/models/reel_model.dart';

class ReelRepository {
  final Dio dio;

  ReelRepository({required this.dio});

  Future<Map<String, String>> _authHeaders() async {
    final token = await UserPreferences().getBearerToken();
    return {'Authorization': 'Bearer $token', 'Accept': 'application/json'};
  }

  Future<DataState<List<ReelModel>>> getReels(String eventId) async {
    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/events/$eventId/reels',
        options: Options(headers: await _authHeaders()),
      );
      final data = response.data['data'] as List? ?? response.data as List;
      return DataSuccess(data
          .map((e) => ReelModel.fromJson(e as Map<String, dynamic>))
          .toList());
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<ReelModel>> postReel({
    required String eventId,
    required String mediaUrl,
    required String mediaType,
    String? caption,
  }) async {
    try {
      final response = await dio.post(
        '$flockrAPIBaseUrl/events/$eventId/reels',
        data: {
          'media_url': mediaUrl,
          'media_type': mediaType,
          if (caption != null) 'caption': caption,
        },
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess(
          ReelModel.fromJson(response.data['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<String>> deleteReel(String reelId) async {
    try {
      await dio.delete(
        '$flockrAPIBaseUrl/reels/$reelId',
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess('Reel deleted.');
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<String>> likeReel(String reelId) async {
    try {
      final response = await dio.post(
        '$flockrAPIBaseUrl/reels/$reelId/like',
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess(response.data['message'] as String);
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<String>> unlikeReel(String reelId) async {
    try {
      final response = await dio.post(
        '$flockrAPIBaseUrl/reels/$reelId/unlike',
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess(response.data['message'] as String);
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
