import 'package:dio/dio.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/tickets/data/models/ticket_model.dart';

class TicketRepository {
  final Dio dio;

  TicketRepository({required this.dio});

  Future<Map<String, String>> _authHeaders() async {
    final token = await UserPreferences().getBearerToken();
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  Future<DataState<List<TicketModel>>> getMyTickets() async {
    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/tickets',
        options: Options(headers: await _authHeaders()),
      );
      final list = (response.data as List)
          .map((e) => TicketModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return DataSuccess(list);
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<TicketModel>> getEventTicket(String eventId) async {
    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/events/$eventId/ticket',
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess(
          TicketModel.fromJson(response.data['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<List<TicketModel>>> getEventTickets(String eventId) async {
    try {
      final response = await dio.get(
        '$flockrAPIBaseUrl/events/$eventId/tickets',
        options: Options(headers: await _authHeaders()),
      );
      final list = (response.data as List)
          .map((e) => TicketModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return DataSuccess(list);
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  Future<DataState<TicketModel>> validateTicket(
      {required String ticketCode, required String eventId}) async {
    try {
      final response = await dio.post(
        '$flockrAPIBaseUrl/tickets/validate',
        data: {'ticket_code': ticketCode, 'event_id': eventId},
        options: Options(headers: await _authHeaders()),
      );
      return DataSuccess(
          TicketModel.fromJson(response.data['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
