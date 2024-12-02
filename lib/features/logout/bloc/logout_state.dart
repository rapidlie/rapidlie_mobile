part of 'logout_bloc.dart';

class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object> get props => [];
}

class LogoutInitial extends LogoutState {}
class LogoutLoadingState extends LogoutState {}

class LogoutSuccessState extends LogoutState {
  const LogoutSuccessState();
}

class LogoutErrorState extends LogoutState {
  final String error;

  const LogoutErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
