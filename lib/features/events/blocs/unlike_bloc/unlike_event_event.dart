import 'package:equatable/equatable.dart';

class UnlikeEventEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UnlikeToggled extends UnlikeEventEvent {
  final String eventId;

  UnlikeToggled(this.eventId);

  @override
  List<Object> get props => [eventId];
}
