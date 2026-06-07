part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();
  @override
  List<Object?> get props => [];
}

class FetchEventList extends EventEvent {
  final String? categoryId;
  const FetchEventList({this.categoryId});
  @override
  List<Object?> get props => [categoryId];
}

// Backward-compat aliases so existing screen dispatches still compile
class GetPublicEvents extends FetchEventList {
  const GetPublicEvents() : super();
}

class GetPrivateEvents extends FetchEventList {
  const GetPrivateEvents() : super();
}

class GetInvitedEvents extends FetchEventList {
  const GetInvitedEvents() : super();
}

class GetUpcomingEvents extends FetchEventList {
  const GetUpcomingEvents() : super();
}

class GetEventsByCategory extends FetchEventList {
  const GetEventsByCategory(String categoryId) : super(categoryId: categoryId);
}
