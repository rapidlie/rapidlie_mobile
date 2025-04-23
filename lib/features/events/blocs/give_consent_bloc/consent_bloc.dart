import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/events/repository/consent_repository.dart';

part 'consent_event.dart';
part 'consent_state.dart';

class ConsentBloc extends Bloc<ConsentEvent, ConsentState> {
  ConsentRepository consentRepository;
  ConsentBloc({required this.consentRepository}) : super(ConsentInitial()) {
    on<GiveConsentEvent>(_onGiveConsent);
    on<ResetGiveConsentEvent>(_onResetGiveConsentEvent);
  }

  Future<void> _onGiveConsent(
      GiveConsentEvent event, Emitter<ConsentState> emit) async {
    emit(ConsentLoadingState());
    try {
      final result = await consentRepository.giveConsent(
          status: event.status, eventId: event.eventId);
      if (result is DataSuccess) {
        emit(ConsentLoadedState(message: result.toString()));
      }
    } catch (e) {
      emit(ConsentErrorState(error: e.toString()));
    }
  }

  void _onResetGiveConsentEvent(
    ResetGiveConsentEvent event,
    Emitter<ConsentState> emit,
  ) {
    emit(ConsentInitial()); // Emit the initial state
  }
}
