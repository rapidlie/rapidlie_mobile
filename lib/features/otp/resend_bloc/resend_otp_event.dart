part of 'resend_otp_bloc.dart';

class ResendOtpEvent extends Equatable {
  const ResendOtpEvent();

  @override
  List<Object> get props => [];
}

class SubmitResendOtpEvent extends ResendOtpEvent {
  final String email;

  const SubmitResendOtpEvent({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}
