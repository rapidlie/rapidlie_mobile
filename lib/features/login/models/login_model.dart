import 'package:rapidlie/features/user/models/user_model.dart';

class LoginModel {
  final String email;
  final String password;

  LoginModel({
    required this.email,
    required this.password,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class LoginResponse {
  final String accessToken;
  final UserModel user;

  LoginResponse({
    required this.accessToken,
    required this.user,
  });

  // Factory method to create a LoginResponse from JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      user: UserModel.fromJson(json['data']),
    );
  }

  // Method to convert a LoginResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'user': user.toJson(),
    };
  }
}
