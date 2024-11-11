import 'package:equatable/equatable.dart';

class LikeEventEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LikeToggled extends LikeEventEvent {
  final String eventId;

  LikeToggled(this.eventId);

  @override
  List<Object> get props => [eventId];
}
