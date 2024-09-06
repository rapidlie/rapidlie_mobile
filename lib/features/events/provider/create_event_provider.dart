import 'package:flutter/material.dart';
import 'package:rapidlie/features/events/models/create_event_model.dart';

class CreateEventProvider extends ChangeNotifier {
  CreateEventModel event = CreateEventModel();

  void updateEvent({
    String? image,
    String? name,
    String? eventType,
    String? category,
    String? description,
    String? date,
    String? startTime,
    String? endTime,
    String? venue,
    String? mapLocation,
  }) {
    if (image != null) event.image = image;
    if (name != null) event.name = name;
    if (eventType != null) event.eventType = eventType;
    if (category != null) event.category = category;
    if (description != null) event.description = description;
    if (date != null) event.date = date;
    if (startTime != null) event.startTime = startTime;
    if (endTime != null) event.endTime = endTime;
    if (venue != null) event.venue = venue;
    if (mapLocation != null) event.mapLocation = mapLocation;

    notifyListeners();
  }

  void clearEvent() {
    event = CreateEventModel();
    notifyListeners();
  }
}
