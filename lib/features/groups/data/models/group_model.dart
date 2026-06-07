class GroupOwner {
  final String id;
  final String name;
  final String? avatar;

  const GroupOwner({required this.id, required this.name, this.avatar});

  factory GroupOwner.fromJson(Map<String, dynamic> json) => GroupOwner(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        avatar: json['avatar'] as String?,
      );
}

class GroupModel {
  final String id;
  final String name;
  final String? description;
  final String? image;
  final String privacy;
  final int memberCount;
  final bool isMember;
  final bool isOwner;
  final GroupOwner owner;
  final String createdAt;

  const GroupModel({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.privacy,
    required this.memberCount,
    required this.isMember,
    required this.isOwner,
    required this.owner,
    required this.createdAt,
  });

  bool get isPublic => privacy == 'public';

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        image: json['image'] as String?,
        privacy: json['privacy'] as String,
        memberCount: (json['member_count'] as num?)?.toInt() ?? 0,
        isMember: json['is_member'] as bool? ?? false,
        isOwner: json['is_owner'] as bool? ?? false,
        owner: GroupOwner.fromJson(json['owner'] as Map<String, dynamic>),
        createdAt: json['created_at'] as String,
      );
}

class GroupMemberModel {
  final String id;
  final String name;
  final String? avatar;
  final String role;

  const GroupMemberModel({
    required this.id,
    required this.name,
    this.avatar,
    required this.role,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) =>
      GroupMemberModel(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        avatar: json['avatar'] as String?,
        role: json['role'] as String? ?? 'member',
      );
}
