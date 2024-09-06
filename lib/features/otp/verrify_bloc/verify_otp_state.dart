part of 'verify_otp_bloc.dart';

class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  List<Object> get props => [];
}

class VerifyOtpInitialState extends VerifyOtpState {}

class VerifyOtpLoadingState extends VerifyOtpState {}

class VerifyOtpSuccessState extends VerifyOtpState {}

class VerifyOtpErrorState extends VerifyOtpState {
  final String error;

  const VerifyOtpErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
