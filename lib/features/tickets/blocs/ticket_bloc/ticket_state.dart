part of 'ticket_bloc.dart';

abstract class TicketState extends Equatable {
  const TicketState();
  @override
  List<Object?> get props => [];
}

class TicketInitial extends TicketState {}

class TicketLoading extends TicketState {}

class TicketValidating extends TicketState {}

class MyTicketsLoaded extends TicketState {
  final List<TicketModel> tickets;
  const MyTicketsLoaded(this.tickets);
  @override
  List<Object?> get props => [tickets];
}

class EventTicketLoaded extends TicketState {
  final TicketModel ticket;
  const EventTicketLoaded(this.ticket);
  @override
  List<Object?> get props => [ticket];
}

class EventTicketsLoaded extends TicketState {
  final List<TicketModel> tickets;
  const EventTicketsLoaded(this.tickets);
  @override
  List<Object?> get props => [tickets];
}

class TicketValidated extends TicketState {
  final TicketModel ticket;
  const TicketValidated(this.ticket);
  @override
  List<Object?> get props => [ticket];
}

class TicketValidationFailed extends TicketState {
  final String message;
  const TicketValidationFailed(this.message);
  @override
  List<Object?> get props => [message];
}

class TicketError extends TicketState {
  final String message;
  const TicketError(this.message);
  @override
  List<Object?> get props => [message];
}
