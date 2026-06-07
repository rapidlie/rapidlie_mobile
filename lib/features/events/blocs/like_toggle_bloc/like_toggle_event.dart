part of 'like_toggle_bloc.dart';

abstract class LikeToggleEvent extends Equatable {
  const LikeToggleEvent();
  @override
  List<Object> get props => [];
}

class ToggleLike extends LikeToggleEvent {
  final String eventId;
  final bool like;

  const ToggleLike({required this.eventId, required this.like});

  @override
  List<Object> get props => [eventId, like];
}
