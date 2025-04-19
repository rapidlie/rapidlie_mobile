part of 'event_bloc.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object?> get props => [];
}

/*** Public Event ***/
abstract class PublicEventState extends EventState {
  const PublicEventState();

  @override
  List<Object> get props => [];
}

class InitialPublicEventState extends PublicEventState {}

class PublicEventLoading extends PublicEventState {}

class PublicEventLoaded extends PublicEventState {
  final List<EventDataModel> events;

  const PublicEventLoaded({required this.events});

  @override
  List<Object> get props => [events];
}

class PublicEventError extends PublicEventState {
  final String message;

  const PublicEventError({required this.message});

  @override
  List<Object> get props => [message];
}

/**** PrivateEvent  ****/
abstract class PrivateEventState extends EventState {
  const PrivateEventState();

  @override
  List<Object> get props => [];
}

class InitialPrivateEventState extends PrivateEventState {}

class PrivateEventLoading extends PrivateEventState {}

class PrivateEventLoaded extends PrivateEventState {
  final List<EventDataModel> events;

  const PrivateEventLoaded({required this.events});

  @override
  List<Object> get props => [events];
}

class PrivateEventError extends PrivateEventState {
  final String message;

  const PrivateEventError({required this.message});

  @override
  List<Object> get props => [message];
}

/*** Invited Events ***/
abstract class InvitedEventState extends EventState {
  const InvitedEventState();

  @override
  List<Object> get props => [];
}

class InitialInvitedEventState extends InvitedEventState {}

class InvitedEventLoading extends InvitedEventState {}

class InvitedEventLoaded extends InvitedEventState {
  final List<EventDataModel> events;

  const InvitedEventLoaded({required this.events});

  @override
  List<Object> get props => [events];
}

class InvitedEventError extends InvitedEventState {
  final String message;

  const InvitedEventError({required this.message});

  @override
  List<Object> get props => [message];
}

/*** Events by category ***/
abstract class UpcomingEventState extends EventState {
  const UpcomingEventState();

  @override
  List<Object> get props => [];
}

class InitialUpcomingEventState extends UpcomingEventState {}

class UpcomingEventLoading extends UpcomingEventState {}

class UpcomingEventLoaded extends UpcomingEventState {
  final List<EventDataModel> events;

  const UpcomingEventLoaded({required this.events});

  @override
  List<Object> get props => [events];
}

class UpcomingEventError extends UpcomingEventState {
  final String message;

  const UpcomingEventError({required this.message});

  @override
  List<Object> get props => [message];
}

/*** Upcoming events ***/
abstract class EventByCategoryState extends EventState {
  const EventByCategoryState();

  @override
  List<Object> get props => [];
}

class InitialEventByCategoryState extends EventByCategoryState {}

class EventByCategoryLoading extends EventByCategoryState {}

class EventByCategoryLoaded extends EventByCategoryState {
  final List<EventDataModel> events;

  const EventByCategoryLoaded({required this.events});
  @override
  List<Object> get props => [events];
}

class EventByCategoryError extends EventByCategoryState {
  final String message;

  const EventByCategoryError({required this.message});

  @override
  List<Object> get props => [message];
}
