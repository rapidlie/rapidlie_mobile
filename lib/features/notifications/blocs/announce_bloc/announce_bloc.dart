import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/notifications/data/device_token_repository.dart';

part 'announce_event.dart';
part 'announce_state.dart';

class AnnounceBloc extends Bloc<AnnounceEvent, AnnounceState> {
  final DeviceTokenRepository repository;

  AnnounceBloc({required this.repository}) : super(AnnounceInitial()) {
    on<SendAnnouncement>(_onSend);
  }

  Future<void> _onSend(
    SendAnnouncement event,
    Emitter<AnnounceState> emit,
  ) async {
    emit(AnnounceLoading());
    final result = await repository.announce(
      eventId: event.eventId,
      title: event.title,
      message: event.message,
    );
    if (result is DataSuccess) {
      emit(AnnounceSuccess(result.data!));
    } else {
      emit(AnnounceError(
          message: (result as DataFailed).error?.message ?? 'Failed'));
    }
  }
}
