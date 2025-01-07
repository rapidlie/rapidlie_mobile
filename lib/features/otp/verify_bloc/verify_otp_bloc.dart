import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/login/models/login_model.dart';
import 'package:rapidlie/features/otp/repository/verify_otp_repositoy.dart';

part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOtpRepository verifyOtpRepository;

  VerifyOtpBloc({required this.verifyOtpRepository})
      : super(VerifyOtpInitialState()) {
    on<SubmitVerifyOtpEvent>(_onSubmitVerifyOtp);
  }

  Future<void> _onSubmitVerifyOtp(
    SubmitVerifyOtpEvent event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(VerifyOtpLoadingState());

    try {
      final result = await verifyOtpRepository.verifyOtp(
        email: event.email,
        otp: event.otp,
      );

      if (result is DataSuccess<LoginResponse>) {
        await UserPreferences().setBearerToken(result.data!.accessToken);
        await UserPreferences().setUserName(result.data!.user.name);
        await UserPreferences().setLoginStatus(true);
        await UserPreferences().setRegistrationStep("complete");
        emit(VerifyOtpSuccessState());
      } else {
        emit(VerifyOtpErrorState(error: "Verify failed"));
      }
    } catch (e) {
      emit(VerifyOtpErrorState(error: e.toString()));
    }
  }
}
