

import 'package:equatable/equatable.dart';

class NewPasswordState extends Equatable {
  const NewPasswordState();

  @override
  List<Object> get props => [];
}

class NewPasswordInitial extends NewPasswordState {}
class NewPasswordLoadingState extends NewPasswordState {}

class NewPasswordSuccessState extends NewPasswordState {
  const NewPasswordSuccessState();
}

class NewPasswordErrorState extends NewPasswordState {
  final String error;

  const NewPasswordErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
