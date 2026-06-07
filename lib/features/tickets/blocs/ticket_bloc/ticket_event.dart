part of 'ticket_bloc.dart';

abstract class TicketEvent extends Equatable {
  const TicketEvent();
  @override
  List<Object?> get props => [];
}

class FetchMyTickets extends TicketEvent {
  const FetchMyTickets();
}

class FetchEventTicket extends TicketEvent {
  final String eventId;
  const FetchEventTicket(this.eventId);
  @override
  List<Object?> get props => [eventId];
}

class FetchEventTickets extends TicketEvent {
  final String eventId;
  const FetchEventTickets(this.eventId);
  @override
  List<Object?> get props => [eventId];
}

class ValidateTicket extends TicketEvent {
  final String ticketCode;
  final String eventId;
  const ValidateTicket({required this.ticketCode, required this.eventId});
  @override
  List<Object?> get props => [ticketCode, eventId];
}
