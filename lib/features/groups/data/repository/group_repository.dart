import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/features/groups/data/models/group_model.dart';

class GroupRepository {
  final Dio dio;
  GroupRepository({required this.dio});

  Future<Map<String, String>> _authHeaders() async {
    final token = await UserPreferences().getBearerToken();
    return {'Authorization': 'Bearer $token', 'Accept': 'application/json'};
  }

  List<GroupModel> _parseGroups(dynamic data) {
    final list = data['data'] as List? ?? data as List;
    return list
        .map((e) => GroupModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<DataState<List<GroupModel>>> getPublicGroups() async {
    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/groups',
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess(_parseGroups(response.data));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<List<GroupModel>>> getMyGroups() async {
    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/my-groups',
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess(_parseGroups(response.data));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<GroupModel>> createGroup({
    required String name,
    String? description,
    String? image,
    String privacy = 'public',
  }) async {
    try {
      final response = await dio.post(
        '$flockrAPIBaseUrl/groups',
        data: {
          'name': name,
          if (description != null) 'description': description,
          if (image != null) 'image': image,
          'privacy': privacy,
        },
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess(
          GroupModel.fromJson(response.data['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<GroupModel>> getGroup(String groupId) async {
    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/groups/$groupId',
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess(GroupModel.fromJson(
          response.data['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<String>> joinGroup(String groupId) async {
    try {
      final response = await dio.post(
        '$flockrAPIBaseUrl/groups/$groupId/join',
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess(response.data['message'] as String);
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<String>> leaveGroup(String groupId) async {
    try {
      final response = await dio.delete(
        '$flockrAPIBaseUrl/groups/$groupId/leave',
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess(response.data['message'] as String);
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<List<GroupMemberModel>>> getMembers(String groupId) async {
    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/groups/$groupId/members',
        options: Options(headers: await _authHeaders()),
      );
      final list = response.data['data'] as List;
      return DataSuccess(list
          .map((e) => GroupMemberModel.fromJson(e as Map<String, dynamic>))
          .toList());
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<List<EventDataModel>>> getGroupEvents(
      String groupId) async {
    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/groups/$groupId/events',
        options: Options(headers: await _authHeaders()),
      );
      final list = response.data['data'] as List? ?? response.data as List;
      return DataSuccess(list
          .map((e) => EventDataModel.fromJson(e as Map<String, dynamic>))
          .toList());
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<GroupModel>> updateGroup(
      String groupId, Map<String, dynamic> fields) async {
    try {
      final response = await dio.patch(
        '$flockrAPIBaseUrl/groups/$groupId',
        data: fields,
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess(
          GroupModel.fromJson(response.data['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<String>> deleteGroup(String groupId) async {
    try {
      final response = await dio.delete(
        '$flockrAPIBaseUrl/groups/$groupId',
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess(
          response.data['message'] as String? ?? 'Group deleted');
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<String>> inviteMember(
      String groupId, String userId) async {
    try {
      final response = await dio.post(
        '$flockrAPIBaseUrl/groups/$groupId/invite',
        data: {'user_id': userId},
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess(
          response.data['message'] as String? ?? 'Invitation sent');
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
