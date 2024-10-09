import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/features/register/models/register_model.dart';

class RegisterRepository {
  final Dio dio;

  RegisterRepository({required this.dio});

  Future<DataState<RegisterResponse>> registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String countryCode,
  }) async {
    try {
      print("User creation started");
      final response = await dio.post(
        '$flockrAPIBaseUrl/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'country_code': countryCode,
        },
        options: Options(
          headers: {
            'Accept': acceptString,
          },
        ),
      );

      if (response.statusCode == 201) {
        print("User creation done");
        final registerResponse = RegisterResponse.fromJson(response.data);
        return DataSuccess(registerResponse);
      } else {
        print("User creation failed");
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
