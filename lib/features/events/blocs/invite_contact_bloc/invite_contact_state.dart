import 'package:equatable/equatable.dart';

abstract class InviteContactState extends Equatable {
  const InviteContactState();

  @override
  List<Object?> get props => [];
}

class InitialInviteContactState extends InviteContactState {}

class InviteContactLoading extends InviteContactState {}

class InviteContactSuccess extends InviteContactState {
  const InviteContactSuccess();

  @override
  List<Object?> get props => [];
}

class InviteContactError extends InviteContactState {
  final String error;

  const InviteContactError(this.error);

  @override
  List<Object?> get props => [error];
}
