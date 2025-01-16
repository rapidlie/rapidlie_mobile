part of 'contacts_bloc.dart';

class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object?> get props => [];
}

class ContactsInitial extends ContactsState {}

class ContactLoading extends ContactsState {}

class ContactPermissionDenied extends ContactsState {}

class ContactLoaded extends ContactsState {
  final List<Contact> contacts;

  ContactLoaded(this.contacts);

  @override
  List<Object?> get props => [contacts];
}

class ContactError extends ContactsState {
  final String error;

  ContactError(this.error);

  @override
  List<Object?> get props => [error];
}
