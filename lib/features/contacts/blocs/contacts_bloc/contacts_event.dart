part of 'contacts_bloc.dart';

abstract class ContactsEvent extends Equatable {
  const ContactsEvent();

  @override
  List<Object> get props => [];
}

class RequestPermissionEvent extends ContactsEvent {}

class FetchContactsEvent extends ContactsEvent {}

class MatchContactsEvent extends ContactsEvent {
  final List<String> phoneNumbers;
  const MatchContactsEvent(this.phoneNumbers);

  @override
  List<Object> get props => [phoneNumbers];
}
