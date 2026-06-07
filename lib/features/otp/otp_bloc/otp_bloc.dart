import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/login/models/login_model.dart';
import 'package:rapidlie/features/otp/repository/resend_otp_repository.dart';
import 'package:rapidlie/features/otp/repository/verify_otp_repositoy.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final VerifyOtpRepository verifyOtpRepository;
  final ResendOtpRepository resendOtpRepository;

  OtpBloc({
    required this.verifyOtpRepository,
    required this.resendOtpRepository,
  }) : super(OtpInitial()) {
    on<SubmitVerifyOtp>(_onVerify);
    on<SubmitResendOtp>(_onResend);
  }

  Future<void> _onVerify(
    SubmitVerifyOtp event,
    Emitter<OtpState> emit,
  ) async {
    emit(OtpVerifyLoading());
    try {
      final result = await verifyOtpRepository.verifyOtp(
        email: event.email,
        otp: event.otp,
      );
      if (result is DataSuccess<LoginResponse>) {
        await UserPreferences().setBearerToken(result.data!.accessToken);
        await UserPreferences().setUserName(result.data!.user.name);
        await UserPreferences().setLoginStatus(true);
        await UserPreferences().setRegistrationStep('complete');
        emit(OtpVerifySuccess());
      } else {
        emit(const OtpVerifyError(message: 'Verification failed'));
      }
    } catch (e) {
      emit(OtpVerifyError(message: e.toString()));
    }
  }

  Future<void> _onResend(
    SubmitResendOtp event,
    Emitter<OtpState> emit,
  ) async {
    emit(OtpResendLoading());
    try {
      final success = await resendOtpRepository.resendOtp(email: event.email);
      if (success) {
        emit(OtpResendSuccess());
      } else {
        emit(const OtpResendError(message: 'Failed to resend OTP'));
      }
    } catch (e) {
      emit(OtpResendError(message: e.toString()));
    }
  }
}
