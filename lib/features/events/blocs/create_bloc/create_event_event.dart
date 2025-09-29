part of 'create_event_bloc.dart';

class CreateEventEvent extends Equatable {
  const CreateEventEvent();

  @override
  List<Object> get props => [];
}

class SubmitCreateEventEvent extends CreateEventEvent {
  final String image;
  final String name;
  final String eventType;
  final String category;
  final String description;
  final String date;
  final String startTime;
  final String endTime;
  final String venue;
  final String mapLocation;
  final List<String>? guests;

  SubmitCreateEventEvent(
      {required this.image,
      required this.name,
      required this.eventType,
      required this.category,
      required this.description,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.venue,
      required this.mapLocation,
      required this.guests});

  @override
  List<Object> get props => [
        image,
        name,
        eventType,
        category,
        description,
        date,
        startTime,
        endTime,
        venue,
        mapLocation,
        guests ?? []
      ];
}

class ResetCreateEvent extends CreateEventEvent {
  @override
  List<Object> get props => [];
}