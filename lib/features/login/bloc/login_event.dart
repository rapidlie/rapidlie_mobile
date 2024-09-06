part of 'login_bloc.dart';

class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class SubmitLoginEvent extends LoginEvent {
  final String email;
  final String password;

  const SubmitLoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
