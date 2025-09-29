import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/events/blocs/like_bloc/like_event_event.dart';
import 'package:rapidlie/features/events/blocs/like_bloc/like_event_state.dart';
import 'package:rapidlie/features/events/repository/like_event_repository.dart';

class LikeEventBloc extends Bloc<LikeEventEvent, LikeEventState> {
  final LikeEventRepository likeEventRepository;
  LikeEventBloc({required this.likeEventRepository})
      : super(InitialLikeEventState()) {
    on<LikeToggled>(_onLikeEvent);
  }

  Future<void> _onLikeEvent(
    LikeToggled event,
    Emitter<LikeEventState> emit,
  ) async {
    emit(LikeEventLoading());
    try {
      final likeEventResponse =
          await likeEventRepository.likeEvent(event.eventId);

      if (likeEventResponse is DataSuccess) {
        final newIsLikedStatus = likeEventResponse.data as bool;
        emit(LikeEventLoaded(isLiked: newIsLikedStatus));
      } else if (likeEventResponse is DataFailed) {
        emit(LikeEventError(message: likeEventResponse.error.toString()));
      }
    } catch (e) {
      emit(LikeEventError(message: e.toString()));
    }
  }
}
