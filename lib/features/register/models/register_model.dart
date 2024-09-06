import 'package:rapidlie/features/user/models/user_model.dart';

class RegisterModel {
  final String name;
  final String email;
  final String password;
  final String phone;

  RegisterModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });

  // Factory constructor to create an instance from JSON
  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    };
  }
}

class RegisterResponse {
  final String message;
  final UserModel user;

  RegisterResponse({
    required this.message,
    required this.user,
  });

  // Factory method to create a LoginResponse from JSON
  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'],
      user: UserModel.fromJson(json['user']),
    );
  }

  // Method to convert a LoginResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
    };
  }
}
