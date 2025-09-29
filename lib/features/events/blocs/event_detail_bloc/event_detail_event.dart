part of 'event_detail_bloc.dart';

abstract class EventDetailEvent extends Equatable {
  const EventDetailEvent();

  @override
  List<Object> get props => [];
}

class GetEventDetail extends EventDetailEvent {
  final String eventId;

  const GetEventDetail(this.eventId);

  @override
  List<Object> get props => [eventId];
}
