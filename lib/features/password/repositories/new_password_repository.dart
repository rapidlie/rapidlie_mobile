import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';

class NewPasswordRepository {
  final Dio dio;

  NewPasswordRepository({required this.dio});

  Future<DataState<String>> newPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '$flockrAPIBaseUrl/password/reset',
        options: Options(
          headers: {
            'Accept': acceptString,
          },
        ),
        data: {
          'email': email,
          'otp': otp,
          'password': password,
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
