import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/tickets/data/models/ticket_model.dart';
import 'package:rapidlie/features/tickets/data/repository/ticket_repository.dart';

part 'ticket_event.dart';
part 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository ticketRepository;

  TicketBloc({required this.ticketRepository}) : super(TicketInitial()) {
    on<FetchMyTickets>(_onFetchMyTickets);
    on<FetchEventTicket>(_onFetchEventTicket);
    on<FetchEventTickets>(_onFetchEventTickets);
    on<ValidateTicket>(_onValidateTicket);
  }

  Future<void> _onFetchMyTickets(
      FetchMyTickets event, Emitter<TicketState> emit) async {
    emit(TicketLoading());
    final result = await ticketRepository.getMyTickets();
    if (result is DataSuccess<List<TicketModel>>) {
      emit(MyTicketsLoaded(result.data!));
    } else {
      emit(TicketError(
          result.error?.response?.data['message'] as String? ??
              'Failed to load tickets'));
    }
  }

  Future<void> _onFetchEventTicket(
      FetchEventTicket event, Emitter<TicketState> emit) async {
    emit(TicketLoading());
    final result = await ticketRepository.getEventTicket(event.eventId);
    if (result is DataSuccess<TicketModel>) {
      emit(EventTicketLoaded(result.data!));
    } else {
      emit(TicketError(
          result.error?.response?.data['message'] as String? ??
              'No ticket found'));
    }
  }

  Future<void> _onFetchEventTickets(
      FetchEventTickets event, Emitter<TicketState> emit) async {
    emit(TicketLoading());
    final result = await ticketRepository.getEventTickets(event.eventId);
    if (result is DataSuccess<List<TicketModel>>) {
      emit(EventTicketsLoaded(result.data!));
    } else {
      emit(TicketError(
          result.error?.response?.data['message'] as String? ??
              'Failed to load tickets'));
    }
  }

  Future<void> _onValidateTicket(
      ValidateTicket event, Emitter<TicketState> emit) async {
    emit(TicketValidating());
    final result = await ticketRepository.validateTicket(
        ticketCode: event.ticketCode, eventId: event.eventId);
    if (result is DataSuccess<TicketModel>) {
      emit(TicketValidated(result.data!));
    } else {
      emit(TicketValidationFailed(
          result.error?.response?.data['message'] as String? ??
              'Invalid ticket'));
    }
  }
}
