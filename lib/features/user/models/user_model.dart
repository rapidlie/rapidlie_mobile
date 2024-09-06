class UserModel {
  final String uuid;
  final String name;
  final String email;
  final String phone;
  final String? country;
  final String? avatar;

  UserModel({
    required this.uuid,
    required this.name,
    required this.email,
    required this.phone,
    this.country,
    this.avatar,
  });

  // Factory method to create a DataModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uuid: json['uuid'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      country: json['country'],
      avatar: json['avatar'],
    );
  }

  // Method to convert a DataModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'email': email,
      'phone': phone,
      'country': country,
      'avatar': avatar,
    };
  }
}
