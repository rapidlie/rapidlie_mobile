class ReelUser {
  final String id;
  final String name;
  final String? avatar;

  const ReelUser({required this.id, required this.name, this.avatar});

  factory ReelUser.fromJson(Map<String, dynamic> json) => ReelUser(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        avatar: json['avatar'] as String?,
      );
}

class ReelModel {
  final String id;
  final String mediaUrl;
  final String mediaType;
  final String? caption;
  final int likes;
  final bool hasLiked;
  final ReelUser postedBy;
  final String eventId;
  final String createdAt;

  const ReelModel({
    required this.id,
    required this.mediaUrl,
    required this.mediaType,
    this.caption,
    required this.likes,
    required this.hasLiked,
    required this.postedBy,
    required this.eventId,
    required this.createdAt,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) => ReelModel(
        id: json['id'] as String,
        mediaUrl: json['media_url'] as String,
        mediaType: json['media_type'] as String,
        caption: json['caption'] as String?,
        likes: (json['likes'] as num?)?.toInt() ?? 0,
        hasLiked: json['has_liked'] as bool? ?? false,
        postedBy: ReelUser.fromJson(
            json['posted_by'] as Map<String, dynamic>),
        eventId: json['event_id'] as String,
        createdAt: json['created_at'] as String,
      );

  bool get isVideo => mediaType == 'video';

  ReelModel copyWith({int? likes, bool? hasLiked}) => ReelModel(
        id: id,
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        caption: caption,
        likes: likes ?? this.likes,
        hasLiked: hasLiked ?? this.hasLiked,
        postedBy: postedBy,
        eventId: eventId,
        createdAt: createdAt,
      );
}
