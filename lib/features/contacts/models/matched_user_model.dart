import 'package:equatable/equatable.dart';

class MatchedUserModel extends Equatable {
  final String uuid;
  final String name;
  final String phone;
  final String? avatar;

  const MatchedUserModel({
    required this.uuid,
    required this.name,
    required this.phone,
    this.avatar,
  });

  factory MatchedUserModel.fromJson(Map<String, dynamic> json) {
    return MatchedUserModel(
      uuid: json['uuid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      avatar: json['avatar'] as String?,
    );
  }

  @override
  List<Object?> get props => [uuid, name, phone, avatar];
}
