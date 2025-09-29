

import 'package:equatable/equatable.dart';

class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object> get props => [];
}

class ChangePasswordInitial extends ChangePasswordState {}
class ChangePasswordLoadingState extends ChangePasswordState {}

class ChangePasswordSuccessState extends ChangePasswordState {
  const ChangePasswordSuccessState();
}

class ChangePasswordErrorState extends ChangePasswordState {
  final String error;

  const ChangePasswordErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
