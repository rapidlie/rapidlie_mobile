import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/settings/models/user_setting_model.dart';

class UserSettingRepository {
  final Dio dio;
  UserSettingRepository({required this.dio});

  Future<Map<String, String>> _headers() async {
    final token = await UserPreferences().getBearerToken();
    return {'Authorization': 'Bearer $token', 'Accept': 'application/json'};
  }

  Future<DataState<UserSettingModel>> getSettings() async {
    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/settings',
        options: Options(headers: await _headers()),
      );
      return DataSuccess(UserSettingModel.fromJson(
          response.data['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<UserSettingModel>> updateSettings(
      Map<String, dynamic> fields) async {
    try {
      final response = await dio.patch(
        '$flockrAPIBaseUrl/settings',
        data: fields,
        options: Options(headers: await _headers()),
      );
      return DataSuccess(UserSettingModel.fromJson(
          response.data['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<String>> disableBiometric() async {
    try {
      final response = await dio.delete(
        '$flockrAPIBaseUrl/auth/biometric/disable',
        options: Options(headers: await _headers()),
      );
      return DataSuccess(
          response.data['message'] as String? ?? 'Biometric disabled');
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
