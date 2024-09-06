import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/categories/models/category_model.dart';

class CategoryRepository {
  final Dio dio;

  CategoryRepository({required this.dio});

  Future<DataState<List<CategoryModel>>> getCategories() async {
    String bearerToken = await UserPreferences().getBearerToken();
    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/categories',
        options: Options(
          headers: {
            'Authorization': "Bearer " + bearerToken,
            'Accept': acceptString,
          },
        ),
      );
      if (response.statusCode == HttpStatus.ok) {
        List<dynamic> data = response.data['data'];
        List<CategoryModel> categories =
            data.map((item) => CategoryModel.fromJson(item)).toList();
        return DataSuccess(categories);
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
