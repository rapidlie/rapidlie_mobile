part of 'like_toggle_bloc.dart';

class LikeToggleRepository {
  final Dio dio;

  LikeToggleRepository({required this.dio});

  Future<DataState<String>> toggleLike({
    required String eventId,
    required bool like,
  }) async {
    final bearerToken = await UserPreferences().getBearerToken();
    final endpoint = like ? 'like' : 'unlike';

    try {
      final response = await dio.post(
        '$flockrAPIBaseUrl/events/$eventId/$endpoint',
        options: Options(
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Accept': acceptString,
          },
        ),
        data: {},
      );

      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess('success');
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
