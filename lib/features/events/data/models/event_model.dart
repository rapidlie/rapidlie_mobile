import 'package:rapidlie/features/events/domain/entities/event_entity.dart';

class EventModel extends EventEntity {
  EventModel(
      {required List<EventData> data, required Links links, required Meta meta})
      : super(data: data, links: links, meta: meta);

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      data: List<EventData>.from(
          json['data'].map((x) => EventDataModel.fromJson(x))),
      links: LinksModel.fromJson(json['links']),
      meta: MetaModel.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((x) => (x as EventDataModel).toJson()).toList(),
      'links': (links as LinksModel).toJson(),
      'meta': (meta as MetaModel).toJson(),
    };
  }
}

class EventDataModel extends EventData {
  EventDataModel(
      {required String id,
      required String name,
      required String eventType,
      required Category category,
      required String description,
      required String date,
      required String startTime,
      required String endTime,
      required String venue,
      required String mapLocation,
      required String image,
      required int likes,
      required int formattedLikes})
      : super(
          id: id,
          name: name,
          eventType: eventType,
          category: category,
          description: description,
          date: date,
          startTime: startTime,
          endTime: endTime,
          venue: venue,
          mapLocation: mapLocation,
          image: image,
          likes: likes,
          formattedLikes: formattedLikes,
        );

  factory EventDataModel.fromJson(Map<String, dynamic> json) {
    return EventDataModel(
      id: json['id'],
      name: json['name'],
      eventType: json['event_type'],
      category: CategoryModel.fromJson(json['category']),
      description: json['description'],
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      venue: json['venue'],
      mapLocation: json['map_location'],
      image: json['image'],
      likes: json['likes'],
      formattedLikes: json['formatted_likes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'event_type': eventType,
      'category': (category as CategoryModel).toJson(),
      'description': description,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'venue': venue,
      'map_location': mapLocation,
      'image': image,
      'likes': likes,
      'formatted_likes': formattedLikes,
    };
  }
}

class CategoryModel extends Category {
  CategoryModel({
    required String id,
    required String name,
    required String image,
  }) : super(id: id, name: name, image: image);

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}

class LinksModel extends Links {
  LinksModel({
    String? first,
    String? last,
    String? prev,
    String? next,
  }) : super(first: first, last: last, prev: prev, next: next);

  factory LinksModel.fromJson(Map<String, dynamic> json) {
    return LinksModel(
      first: json['first'],
      last: json['last'],
      prev: json['prev'],
      next: json['next'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first': first,
      'last': last,
      'prev': prev,
      'next': next,
    };
  }
}

class MetaModel extends Meta {
  MetaModel({
    required int currentPage,
    required int from,
    required int lastPage,
    required List<Link> links,
    required String path,
    required int perPage,
    required int to,
    required int total,
  }) : super(
            currentPage: currentPage,
            from: from,
            lastPage: lastPage,
            links: links,
            path: path,
            perPage: perPage,
            to: to,
            total: total);

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      currentPage: json['current_page'],
      from: json['from'],
      lastPage: json['last_page'],
      links: List<LinkModel>.from(
        json['links'].map((x) => LinkModel.fromJson(x)),
      ),
      path: json['path'],
      perPage: json['per_page'],
      to: json['to'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'from': from,
      'last_page': lastPage,
      'links': links.map((x) => (x as LinkModel).toJson()).toList(),
      'path': path,
      'per_page': perPage,
      'to': to,
      'total': total,
    };
  }
}

class LinkModel extends Link {
  LinkModel({
    String? url,
    required String label,
    required bool active,
  }) : super(url: url, label: label, active: active);

  factory LinkModel.fromJson(Map<String, dynamic> json) {
    return LinkModel(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}
