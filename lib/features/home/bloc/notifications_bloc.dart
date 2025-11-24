import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/home/models/notification.dart';
import 'package:rapidlie/features/home/notification_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsRepository notificationsRepository;
  List<FlashNotifications>? _cachedNotifications;

  NotificationsBloc({required this.notificationsRepository})
      : super(NotificationsInitialState()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
  }

  Future<void> _onFetchNotifications(
    FetchNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoadingState());
    if (_cachedNotifications != null) {
      emit(NotificationsLoadedState(notifications: _cachedNotifications!));
      return;
    }
    try {
      final notificationsResponse =
          await notificationsRepository.getNotifications();

      if (notificationsResponse is DataSuccess<List<FlashNotifications>>) {
        _cachedNotifications = notificationsResponse.data;
        emit(NotificationsLoadedState(
            notifications: notificationsResponse.data!));
      } else if (notificationsResponse is DataFailed) {
        emit(NotificationsErrorState(
            error: notificationsResponse.error.toString()));
      }
    } catch (e) {
      emit(NotificationsErrorState(error: e.toString()));
    }
  }
}
