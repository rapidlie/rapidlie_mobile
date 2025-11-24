class FlashNotifications {
  int id;
  String title;
  String headline;
  String description;
  String noticeType;
  String? image;
  DateTime createdAt;
  DateTime updatedAt;

  FlashNotifications({
    required this.id,
    required this.title,
    required this.headline,
    required this.description,
    required this.noticeType,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FlashNotifications.fromJson(Map<String, dynamic> json) => FlashNotifications(
        id: json["id"],
        title: json["title"],
        headline: json["headline"],
        description: json["description"],
        noticeType: json["notice_type"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "headline": headline,
        "description": description,
        "notice_type": noticeType,
        "image": image,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
