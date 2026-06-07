part of 'event_bloc.dart';

abstract class EventListState extends Equatable {
  const EventListState();
  @override
  List<Object?> get props => [];
}

class EventListInitial extends EventListState {}

class EventListLoading extends EventListState {}

class EventListLoaded extends EventListState {
  final List<EventDataModel> events;
  const EventListLoaded({required this.events});
  @override
  List<Object> get props => [events];
}

class EventListError extends EventListState {
  final String message;
  const EventListError({required this.message});
  @override
  List<Object> get props => [message];
}

// Backward-compat aliases so existing BlocBuilder state checks still compile
class PublicEventState extends EventListState {}

class PublicEventLoading extends EventListLoading {}

class PublicEventLoaded extends EventListLoaded {
  const PublicEventLoaded({required super.events});
}

class PublicEventError extends EventListError {
  const PublicEventError({required super.message});
}

class PrivateEventState extends EventListState {}

class PrivateEventLoading extends EventListLoading {}

class PrivateEventLoaded extends EventListLoaded {
  const PrivateEventLoaded({required super.events});
}

class PrivateEventError extends EventListError {
  const PrivateEventError({required super.message});
}

class InvitedEventState extends EventListState {}

class InvitedEventLoading extends EventListLoading {}

class InvitedEventLoaded extends EventListLoaded {
  const InvitedEventLoaded({required super.events});
}

class InvitedEventError extends EventListError {
  const InvitedEventError({required super.message});
}

class UpcomingEventState extends EventListState {}

class UpcomingEventLoading extends EventListLoading {}

class UpcomingEventLoaded extends EventListLoaded {
  const UpcomingEventLoaded({required super.events});
}

class UpcomingEventError extends EventListError {
  const UpcomingEventError({required super.message});
}

class EventByCategoryState extends EventListState {}

class EventByCategoryLoading extends EventListLoading {}

class EventByCategoryLoaded extends EventListLoaded {
  const EventByCategoryLoaded({required super.events});
}

class EventByCategoryError extends EventListError {
  const EventByCategoryError({required super.message});
}
