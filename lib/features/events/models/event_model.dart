import 'package:equatable/equatable.dart';
import 'package:rapidlie/features/categories/models/category_model.dart';

class EventResponseModel extends Equatable {
  final List<EventDataModel> data;
  final LinksModel? links;
  final MetaModel? meta;

  EventResponseModel({
    required this.data,
    required this.links,
    required this.meta,
  }) : super();

  factory EventResponseModel.fromJson(Map<String, dynamic> json) {
    return EventResponseModel(
      data: json['data'] != null
          ? List<EventDataModel>.from((json['data'] as List<dynamic>)
              .map((x) => EventDataModel.fromJson(x)))
          : [],
      links: json['links'] != null
          ? LinksModel.fromJson(json['links'])
          : LinksModel(), // Provide default or nullable LinksModel
      meta: json['meta'] != null
          ? MetaModel.fromJson(json['meta'])
          : MetaModel(
              // Provide default values
              currentPage: 0,
              from: 0,
              lastPage: 0,
              links: [],
              path: '',
              perPage: 0,
              to: 0,
              total: 0,
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((x) => x.toJson()).toList(),
      'links': links!.toJson(),
      'meta': meta!.toJson(),
    };
  }

  @override
  List<Object?> get props => [data, links, meta];
}

class EventDataModel extends Equatable {
  final String id;
  final String name;
  final String eventType;
  final CategoryModel category;
  final String description;
  final String date;
  final String startTime;
  final String endTime;
  final String venue;
  final String mapLocation;
  final String? image;
  final List<dynamic> invitations;
  final int likes;
  final bool hasLikedEvent;
  final int formattedLikes;
  final String username;

  EventDataModel({
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
    this.image,
    required this.hasLikedEvent,
    required this.invitations,
    required this.likes,
    required this.formattedLikes,
    required this.username,
  }) : super();

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
      invitations: List<dynamic>.from(json['invitations']),
      likes: json['likes'],
      hasLikedEvent: json['hasLikedEvent'],
      formattedLikes: json['formatted_likes'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'event_type': eventType,
      'category': category.toJson(),
      'description': description,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'venue': venue,
      'map_location': mapLocation,
      'image': image,
      'invitations': invitations,
      'likes': likes,
      'hasLikedEvent': hasLikedEvent,
      'formatted_likes': formattedLikes,
      'username': username,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        eventType,
        category,
        description,
        date,
        startTime,
        endTime,
        venue,
        mapLocation,
        image,
        invitations,
        likes,
        formattedLikes,
        username,
        hasLikedEvent,
      ];
}

/* class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String image;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
  }) : super();

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

  @override
  List<Object?> get props => [id, name, image];
} */

class LinksModel extends Equatable {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  LinksModel({
    this.first,
    this.last,
    this.prev,
    this.next,
  }) : super();

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

  @override
  List<Object?> get props => [first, last, prev, next];
}

class MetaModel extends Equatable {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<LinkModel>? links;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

  MetaModel({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  }) : super();

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      currentPage: json['current_page'],
      from: json['from'],
      lastPage: json['last_page'],
      links:
          List<LinkModel>.from(json['links'].map((x) => LinkModel.fromJson(x))),
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
      'links': links!.map((x) => x.toJson()).toList(),
      'path': path,
      'per_page': perPage,
      'to': to,
      'total': total,
    };
  }

  @override
  List<Object?> get props => [
        currentPage,
        from,
        lastPage,
        links,
        path,
        perPage,
        to,
        total,
      ];
}

class LinkModel extends Equatable {
  final String? url;
  final String label;
  final bool active;

  LinkModel({
    this.url,
    required this.label,
    required this.active,
  }) : super();

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

  @override
  List<Object?> get props => [url, label, active];
}
