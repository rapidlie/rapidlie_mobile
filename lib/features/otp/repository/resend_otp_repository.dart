import 'package:dio/dio.dart';
import 'package:rapidlie/core/constants/strings.dart';

class ResendOtpRepository {
  final Dio dio;

  ResendOtpRepository({required this.dio});

  Future<bool> resendOtp({
    required String email,
  }) async {
    try {
      final response = await dio.post(
        '$flockrAPIBaseUrl/resend/otp',
        data: {
          'email': email,
        },
        options: Options(
          headers: {
            'Accept': acceptString,
          },
        ),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      print(e.error);
      return false;
    }
  }
}
