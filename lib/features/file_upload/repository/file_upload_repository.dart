import 'dart:io';
import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';

class FileUploadRepository {
  final Dio dio;

  FileUploadRepository({required Dio dio}) : dio = Dio();

  Future<DataState<String>> uploadFile(File file) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
      });

      Response response = await dio.post(
        '$flockrAPIBaseUrl/file-upload',
        data: formData,
        options: Options(
          headers: {
            'Authorization': "Bearer " + UserPreferences().getBearerToken(),
            'Accept': acceptString,
          },
        ),
      );

      if (response.statusCode == 201) {
        return DataSuccess(response.data['data']);
      } else {
        return DataFailed(DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ));
      }
    } on DioException catch (dioError) {
      return DataFailed(dioError);
    }
  }
}
