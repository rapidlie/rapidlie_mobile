import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  List<Contact> _cachedContacts = [];
  ContactsBloc() : super(ContactsInitial()) {
    on<RequestPermissionEvent>(_onRequestPermission);
    on<FetchContactsEvent>(_onFetchContacts);
  }

  List<Contact> get cachedContacts => _cachedContacts;

  Future<void> _onRequestPermission(
      RequestPermissionEvent event, Emitter<ContactsState> emit) async {
    emit(ContactLoading());
    try {
      bool permissionGranted = await FlutterContacts.requestPermission();
      if (permissionGranted) {
        add(FetchContactsEvent()); // Trigger fetching contacts
      } else {
        emit(ContactPermissionDenied());
      }
    } catch (e) {
      emit(ContactError(e.toString()));
    }
  }

  Future<void> _onFetchContacts(
      FetchContactsEvent event, Emitter<ContactsState> emit) async {
    emit(ContactLoading());
    try {
      bool permissionGranted = await FlutterContacts.requestPermission();
      if (!permissionGranted) {
        emit(ContactPermissionDenied());
        return;
      } else {
        List<Contact> contacts = await FlutterContacts.getContacts(
          withProperties: true,
        );
        _cachedContacts = contacts;
        emit(ContactLoaded(contacts));
      }
    } catch (e) {
      emit(ContactError(e.toString()));
    }
  }
}
