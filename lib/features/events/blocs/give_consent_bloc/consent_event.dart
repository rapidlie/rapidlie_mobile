part of 'consent_bloc.dart';

class ConsentEvent extends Equatable {
  const ConsentEvent();

  @override
  List<Object> get props => [];
}

class GiveConsentEvent extends ConsentEvent {
  final String status;
  final String eventId;
  GiveConsentEvent({required this.status, required this.eventId});
}

class ResetGiveConsentEvent extends ConsentEvent {
  @override
  List<Object> get props => [];
}
