part of 'resend_otp_bloc.dart';

class ResendOtpState extends Equatable {
  const ResendOtpState();

  @override
  List<Object> get props => [];
}

class ResendOtpInitialState extends ResendOtpState {}

class ResendOtpLoadingState extends ResendOtpState {}

class ResendOtpSuccessState extends ResendOtpState {}

class ResendOtpErrorState extends ResendOtpState {
  final String error;

  const ResendOtpErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
