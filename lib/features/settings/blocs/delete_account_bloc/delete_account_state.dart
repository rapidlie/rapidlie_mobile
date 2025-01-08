part of 'delete_account_bloc.dart';

class DeleteAccountState extends Equatable {
  const DeleteAccountState();

  @override
  List<Object> get props => [];
}

class DeleteAccountInitialState extends DeleteAccountState {}

class DeleteAccountLoadingState extends DeleteAccountState {}

class DeleteAccountSuccessState extends DeleteAccountState {
  const DeleteAccountSuccessState({required String message});
}

class DeleteAccountErrorState extends DeleteAccountState {
  final String error;

  const DeleteAccountErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
