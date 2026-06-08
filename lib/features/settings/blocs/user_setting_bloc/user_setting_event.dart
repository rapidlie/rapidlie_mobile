part of 'user_setting_bloc.dart';

abstract class UserSettingEvent extends Equatable {
  const UserSettingEvent();
  @override
  List<Object?> get props => [];
}

class FetchSettings extends UserSettingEvent {
  const FetchSettings();
}

class UpdateSetting extends UserSettingEvent {
  final String key;
  final dynamic value;
  const UpdateSetting({required this.key, required this.value});
  @override
  List<Object?> get props => [key, value];
}

class DisableBiometric extends UserSettingEvent {
  const DisableBiometric();
}
