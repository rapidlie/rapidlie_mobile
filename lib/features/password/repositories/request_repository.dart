import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';

class RequestRepository {
  final Dio dio;

  RequestRepository({required this.dio});

  Future<DataState<String>> requestReset({
    required String email,
  }) async {
    try {
      final response = await dio.post(
        '$flockrAPIBaseUrl/password/request-otp',
        options: Options(
          headers: {
            'Accept': acceptString,
          },
        ),
        data: {
          'email': email,
        },
      );

      if (response.statusCode == 200) {
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
