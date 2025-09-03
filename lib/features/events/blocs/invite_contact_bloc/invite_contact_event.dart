import 'package:equatable/equatable.dart';

class InviteContactEvent extends Equatable {
  const InviteContactEvent();

  @override
  List<Object> get props => [];
}

class SubmitInviteContactEvent extends InviteContactEvent {
  final String id;
  final List<String> guests;

  SubmitInviteContactEvent({required this.id, required this.guests});

  @override
  List<Object> get props => [id, guests];
}
/* 
class ResetCreateEvent extends CreateEventEvent {
  @override
  List<Object> get props => [];
} */