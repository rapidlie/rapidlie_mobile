import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/features/otp/repository/resend_otp_repository.dart';

part 'resend_otp_event.dart';
part 'resend_otp_state.dart';

class ResendOtpBloc extends Bloc<ResendOtpEvent, ResendOtpState> {
  final ResendOtpRepository resendOtpRepository;

  ResendOtpBloc({required this.resendOtpRepository})
      : super(ResendOtpInitialState()) {
    on<SubmitResendOtpEvent>(_onSubmitResendOtp);
  }

  Future<void> _onSubmitResendOtp(
    SubmitResendOtpEvent event,
    Emitter<ResendOtpState> emit,
  ) async {
    emit(ResendOtpLoadingState());

    try {
      final result = await resendOtpRepository.resendOtp(email: event.email);
      if (result) {
        emit(ResendOtpSuccessState());
      } else {
        emit(ResendOtpErrorState(error: "Verify failed"));
      }
    } catch (e) {
      emit(ResendOtpErrorState(error: e.toString()));
    }
  }
}
