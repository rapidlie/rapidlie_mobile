import 'package:equatable/equatable.dart';

class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class SubmitChangePasswordEvent extends ChangePasswordEvent {
  final String oldPassword;
  final String newPassword;

  const SubmitChangePasswordEvent({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [];
}
