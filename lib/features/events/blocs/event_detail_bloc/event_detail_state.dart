part of 'event_detail_bloc.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object?> get props => [];
}

/*** Public Event ***/
abstract class EventDetailState extends EventState {
  const EventDetailState();

  @override
  List<Object> get props => [];
}

class InitialEventDetailState extends EventDetailState {}

class EventDetailLoading extends EventDetailState {}

class EventDetailLoaded extends EventDetailState {
  final EventDataModel events;

  const EventDetailLoaded({required this.events});

  @override
  List<Object> get props => [events];
}

class EventDetailError extends EventDetailState {
  final String message;

  const EventDetailError({required this.message});

  @override
  List<Object> get props => [message];
}