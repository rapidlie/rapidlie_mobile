part of 'contacts_bloc.dart';

abstract class ContactsEvent extends Equatable {
  const ContactsEvent();

  @override
  List<Object> get props => [];
}

class RequestPermissionEvent extends ContactsEvent {}

class FetchContactsEvent extends ContactsEvent {}
