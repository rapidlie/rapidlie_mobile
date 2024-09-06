part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final LoginResponse loginResponse;

  const LoginSuccessState({required this.loginResponse});
}

class LoginErrorState extends LoginState {
  final String error;

  const LoginErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
