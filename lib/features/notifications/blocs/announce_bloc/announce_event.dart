part of 'announce_bloc.dart';

abstract class AnnounceEvent extends Equatable {
  const AnnounceEvent();
  @override
  List<Object> get props => [];
}

class SendAnnouncement extends AnnounceEvent {
  final String eventId;
  final String title;
  final String message;
  const SendAnnouncement({
    required this.eventId,
    required this.title,
    required this.message,
  });
  @override
  List<Object> get props => [eventId, title, message];
}
