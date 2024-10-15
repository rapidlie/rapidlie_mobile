part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class GetAllEvents extends EventEvent {
  const GetAllEvents();
}

class GetPublicEvents extends EventEvent {
  const GetPublicEvents();
}

class GetPrivateEvents extends EventEvent {
  const GetPrivateEvents();
}

class GetUpcomingEvents extends EventEvent {
  const GetUpcomingEvents();
}

class GetEventsByCategory extends EventEvent {
  final String categoryId;

  const GetEventsByCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
