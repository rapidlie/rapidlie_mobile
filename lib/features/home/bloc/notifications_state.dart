part of 'notifications_bloc.dart';


class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitialState extends NotificationsState {}

class NotificationsLoadingState extends NotificationsState {}

class NotificationsLoadedState extends NotificationsState {
  final List<FlashNotifications> notifications;

  const NotificationsLoadedState({required this.notifications});

  @override
  List<Object> get props => [notifications];
}

class NotificationsErrorState extends NotificationsState {
  final String error;

  const NotificationsErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
