import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';

part 'like_toggle_event.dart';
part 'like_toggle_state.dart';
part 'like_toggle_repository.dart';

class LikeToggleBloc extends Bloc<LikeToggleEvent, LikeToggleState> {
  final LikeToggleRepository likeToggleRepository;

  LikeToggleBloc({required this.likeToggleRepository})
      : super(LikeToggleInitial()) {
    on<ToggleLike>(_onToggleLike);
  }

  Future<void> _onToggleLike(
    ToggleLike event,
    Emitter<LikeToggleState> emit,
  ) async {
    emit(LikeToggleLoading());
    try {
      final response = await likeToggleRepository.toggleLike(
        eventId: event.eventId,
        like: event.like,
      );
      if (response is DataSuccess) {
        emit(LikeToggleSuccess(isLiked: event.like));
      } else if (response is DataFailed) {
        emit(LikeToggleError(
            message: response.error?.message ?? 'Something went wrong'));
      }
    } catch (e) {
      emit(LikeToggleError(message: e.toString()));
    }
  }
}
