part of 'event_bloc.dart';

abstract class EventState extends Equatable {
  final String eventType;

  const EventState({required this.eventType});

  @override
  List<Object> get props => [eventType];
}

class InitialEventState extends EventState {
  const InitialEventState({required String eventType})
      : super(eventType: eventType);
}

class EventLoading extends EventState {
  const EventLoading({required String eventType}) : super(eventType: eventType);
}

class EventLoaded extends EventState {
  final List<EventDataModel> events;

  const EventLoaded({required String eventType, required this.events})
      : super(eventType: eventType);

  @override
  List<Object> get props => [eventType, events];
}

class EventError extends EventState {
  final String message;

  const EventError({required String eventType, required this.message})
      : super(eventType: eventType);

  @override
  List<Object> get props => [eventType, message];
}
