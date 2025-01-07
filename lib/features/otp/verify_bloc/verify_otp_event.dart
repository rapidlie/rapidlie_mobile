part of 'verify_otp_bloc.dart';

class VerifyOtpEvent extends Equatable {
  const VerifyOtpEvent();

  @override
  List<Object> get props => [];
}

class SubmitVerifyOtpEvent extends VerifyOtpEvent {
  final String email;
  final String otp;

  const SubmitVerifyOtpEvent({
    required this.email,
    required this.otp,
  });

  @override
  List<Object> get props => [email, otp];
}
