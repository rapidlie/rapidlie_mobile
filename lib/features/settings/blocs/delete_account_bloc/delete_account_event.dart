part of 'delete_account_bloc.dart';

class DeleteAccountEvent extends Equatable {
  const DeleteAccountEvent();

  @override
  List<Object> get props => [];
}

class SubmitDeleteAccountEvent extends DeleteAccountEvent {
  final String email;

  const SubmitDeleteAccountEvent({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}
