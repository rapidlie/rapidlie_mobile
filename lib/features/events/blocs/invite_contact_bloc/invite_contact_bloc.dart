import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/events/blocs/invite_contact_bloc/invite_contact_event.dart';
import 'package:rapidlie/features/events/blocs/invite_contact_bloc/invite_contact_state.dart';
import 'package:rapidlie/features/events/repository/invite_contact_repository.dart';

class InviteContactBloc extends Bloc<InviteContactEvent, InviteContactState> {
  final InviteContactRepository inviteContactRepository;

  InviteContactBloc(this.inviteContactRepository)
      : super(InitialInviteContactState()) {
    on<InviteContactEvent>(_onInviteContact);
  }

  Future<void> _onInviteContact(
      InviteContactEvent event, Emitter<InviteContactState> emit) async {
    emit(InviteContactLoading());

    try {
      if (event is SubmitInviteContactEvent) {
        final inviteContactResponse = await inviteContactRepository.inviteContact( 
          guests: event.guests,
          id: event.id,
        );

        if (inviteContactResponse is DataSuccess) {
          emit(InviteContactSuccess());
        } else if (inviteContactResponse is DataFailed) {
          emit(InviteContactError(inviteContactResponse.error.toString()));
        }
      }
    } catch (e) {
      emit(InviteContactError(e.toString()));
    }
  }

}
