part of 'otp_bloc.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();
  @override
  List<Object> get props => [];
}

class SubmitVerifyOtp extends OtpEvent {
  final String email;
  final String otp;
  const SubmitVerifyOtp({required this.email, required this.otp});
  @override
  List<Object> get props => [email, otp];
}

class SubmitResendOtp extends OtpEvent {
  final String email;
  const SubmitResendOtp({required this.email});
  @override
  List<Object> get props => [email];
}
