import 'package:equatable/equatable.dart';

class NewPasswordEvent extends Equatable {
  const NewPasswordEvent();

  @override
  List<Object> get props => [];
}

class SubmitNewPasswordEvent extends NewPasswordEvent {
  final String email;
  final String otp;
  final String password;

  const SubmitNewPasswordEvent({
    required this.otp,
    required this.password,
    required this.email,
  });

  @override
  List<Object> get props => [];
}
