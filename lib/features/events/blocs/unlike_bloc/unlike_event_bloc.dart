import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/events/blocs/unlike_bloc/unlike_event_event.dart';
import 'package:rapidlie/features/events/blocs/unlike_bloc/unlike_event_state.dart';
import 'package:rapidlie/features/events/repository/unlike_event_repository.dart';

class UnlikeEventBloc extends Bloc<UnlikeEventEvent, UnlikeEventState> {
  final UnlikeEventRepository unlikeEventRepository;
  UnlikeEventBloc({required this.unlikeEventRepository})
      : super(InitialUnlikeEventState()) {
    on<UnlikeToggled>(_onUnlikeEvent);
  }

  Future<void> _onUnlikeEvent(
    UnlikeToggled event,
    Emitter<UnlikeEventState> emit,
  ) async {
    emit(UnlikeEventLoading());
    try {
      final unlikeEventResponse =
          await unlikeEventRepository.unlikeEvent(event.eventId);
      if (unlikeEventResponse is DataSuccess) {
        emit(UnlikeEventLoaded());
      } else if (unlikeEventResponse is DataFailed) {
        emit(UnlikeEventError(message: unlikeEventResponse.error.toString()));
      }
    } catch (e) {
      emit(UnlikeEventError(message: e.toString()));
    }
  }
}
