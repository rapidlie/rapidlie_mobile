import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final List<EventData> data;
  final Links links;
  final Meta meta;

  EventEntity({required this.data, required this.links, required this.meta});

  @override
  List<Object?> get props {
    return [data, links, meta];
  }
}

class EventData {
  String id;
  String name;
  String eventType;
  Category category;
  String description;
  String date;
  String startTime;
  String endTime;
  String venue;
  String mapLocation;
  String image;
  int likes;
  int formattedLikes;

  EventData({
    required this.id,
    required this.name,
    required this.eventType,
    required this.category,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.venue,
    required this.mapLocation,
    required this.image,
    required this.likes,
    required this.formattedLikes,
  });
}

class Category {
  String id;
  String name;
  String image;

  Category({required this.id, required this.name, required this.image});

}

class Links {
  String? first;
  String? last;
  String? prev;
  String? next;

  Links({this.first, this.last, this.prev, this.next});

}

class Meta {
  int currentPage;
  int from;
  int lastPage;
  List<Link> links;
  String path;
  int perPage;
  int to;
  int total;

  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });
}

class Link {
  String? url;
  String label;
  bool active;

  Link({this.url, required this.label, required this.active});

  
}
