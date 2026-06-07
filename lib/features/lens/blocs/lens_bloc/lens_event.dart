part of 'lens_bloc.dart';

abstract class LensEvent extends Equatable {
  const LensEvent();
  @override
  List<Object?> get props => [];
}

class FetchInsights extends LensEvent {
  final String eventId;
  const FetchInsights(this.eventId);
  @override
  List<Object?> get props => [eventId];
}
