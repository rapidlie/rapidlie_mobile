import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/services.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/contacts/models/matched_user_model.dart';
import 'package:rapidlie/features/contacts/repository/contact_match_repository.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  List<Contact> _cachedContacts = [];
  final ContactMatchRepository _matchRepository =
      ContactMatchRepository(dio: Dio());

  ContactsBloc() : super(ContactsInitial()) {
    on<RequestPermissionEvent>(_onRequestPermission);
    on<FetchContactsEvent>(_onFetchContacts);
    on<MatchContactsEvent>(_onMatchContacts);
  }

  List<Contact> get cachedContacts => _cachedContacts;

  Future<void> _onRequestPermission(
      RequestPermissionEvent event, Emitter<ContactsState> emit) async {
    // Trigger a fetch — the OS will show the permission dialog on first access.
    add(FetchContactsEvent());
  }

  Future<void> _onFetchContacts(
      FetchContactsEvent event, Emitter<ContactsState> emit) async {
    emit(ContactLoading());
    try {
      final contacts = await FastContacts.allContacts;
      _cachedContacts = contacts;
      emit(ContactLoaded(contacts));
    } on PlatformException catch (e) {
      if (e.code.contains('PERMISSION') || e.code.contains('denied')) {
        emit(ContactPermissionDenied());
      } else {
        emit(ContactError(e.message ?? e.toString()));
      }
    } catch (e) {
      emit(ContactError(e.toString()));
    }
  }

  Future<void> _onMatchContacts(
      MatchContactsEvent event, Emitter<ContactsState> emit) async {
    emit(ContactMatchLoading());
    final result = await _matchRepository.matchContacts(event.phoneNumbers);
    if (result is DataSuccess<List<MatchedUserModel>>) {
      emit(ContactMatchLoaded(result.data!));
    } else {
      emit(const ContactMatchError('Failed to match contacts'));
    }
  }
}
