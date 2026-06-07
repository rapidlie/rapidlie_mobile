part of 'otp_bloc.dart';

abstract class OtpState extends Equatable {
  const OtpState();
  @override
  List<Object?> get props => [];
}

class OtpInitial extends OtpState {}

class OtpVerifyLoading extends OtpState {}

class OtpVerifySuccess extends OtpState {}

class OtpVerifyError extends OtpState {
  final String message;
  const OtpVerifyError({required this.message});
  @override
  List<Object> get props => [message];
}

class OtpResendLoading extends OtpState {}

class OtpResendSuccess extends OtpState {}

class OtpResendError extends OtpState {
  final String message;
  const OtpResendError({required this.message});
  @override
  List<Object> get props => [message];
}
