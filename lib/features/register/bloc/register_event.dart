part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class SubmitRegisterEvent extends RegisterEvent {
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String countryCode;
  final String profileImage;

  SubmitRegisterEvent(
      {required this.name,
      required this.email,
      required this.password,
      this.phone,
      required this.countryCode,
      required this.profileImage});

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        phone,
        profileImage,
      ];
}
