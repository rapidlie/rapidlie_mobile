part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class GetPublicEvents extends EventEvent {
  const GetPublicEvents();
}

class GetPrivateEvents extends EventEvent {
  const GetPrivateEvents();
}

class GetInvitedEvents extends EventEvent {
  const GetInvitedEvents();
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
