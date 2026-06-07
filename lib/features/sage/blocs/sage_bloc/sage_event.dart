part of 'sage_bloc.dart';

abstract class SageEvent extends Equatable {
  const SageEvent();
  @override
  List<Object?> get props => [];
}

class FetchSageSuggestions extends SageEvent {
  final String eventId;
  final String? question;
  const FetchSageSuggestions({required this.eventId, this.question});
  @override
  List<Object?> get props => [eventId, question];
}
