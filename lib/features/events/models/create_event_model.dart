import 'package:equatable/equatable.dart';

class CreateEventModel extends Equatable {
  String? image;
  String? name;
  String? eventType;
  String? category;
  String? description;
  String? date;
  String? startTime;
  String? endTime;
  String? venue;
  String? mapLocation;

  CreateEventModel({
    this.image,
    this.name,
    this.eventType,
    this.category,
    this.description,
    this.date,
    this.startTime,
    this.endTime,
    this.venue,
    this.mapLocation,
  });

  // Factory constructor to create an instance from JSON
  factory CreateEventModel.fromJson(Map<String, dynamic> json) {
    return CreateEventModel(
      image: json['image'],
      name: json['name'],
      eventType: json['event_type'],
      category: json['category'],
      description: json['description'],
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      venue: json['venue'],
      mapLocation: json['map_location'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'event_type': eventType,
      'category': category,
      'description': description,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'venue': venue,
      'map_location': mapLocation,
    };
  }

  @override
  List<Object?> get props => [
        image,
        name,
        eventType,
        category,
        description,
        date,
        startTime,
        endTime,
        venue,
        mapLocation
      ];
}
