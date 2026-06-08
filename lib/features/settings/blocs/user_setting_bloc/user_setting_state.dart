part of 'user_setting_bloc.dart';

abstract class UserSettingState extends Equatable {
  const UserSettingState();
  @override
  List<Object?> get props => [];
}

class UserSettingInitial extends UserSettingState {}

class UserSettingLoading extends UserSettingState {}

class UserSettingLoaded extends UserSettingState {
  final UserSettingModel settings;
  const UserSettingLoaded(this.settings);
  @override
  List<Object?> get props => [settings];
}

class UserSettingError extends UserSettingState {
  final String message;
  const UserSettingError(this.message);
  @override
  List<Object?> get props => [message];
}
