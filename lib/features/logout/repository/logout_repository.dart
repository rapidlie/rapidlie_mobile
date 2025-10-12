import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';

class LogoutRepository {
  final Dio dio;

  LogoutRepository({required this.dio});

  Future<DataState<String>> logoutUser() async {
    try {
      final response = await dio.post(
        '$flockrAPIBaseUrl/logout',
        options: Options(
          headers: {
            'Authorization': "Bearer " + UserPreferences().getBearerToken(),
            'Accept': acceptString,
          },
        ),
      );

      if (response.statusCode == 201) {
        return DataSuccess("success");
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
