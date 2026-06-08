import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/settings/models/user_setting_model.dart';
import 'package:rapidlie/features/settings/repositories/user_setting_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'user_setting_event.dart';
part 'user_setting_state.dart';

class UserSettingBloc extends Bloc<UserSettingEvent, UserSettingState> {
  final UserSettingRepository repository;

  UserSettingBloc({required this.repository}) : super(UserSettingInitial()) {
    on<FetchSettings>(_onFetch);
    on<UpdateSetting>(_onUpdate);
    on<DisableBiometric>(_onDisableBiometric);
  }

  String _err(DataState s) =>
      s.error?.response?.data['message'] as String? ?? 'Something went wrong';

  UserSettingModel _apply(UserSettingModel m, String key, dynamic value) {
    switch (key) {
      case 'push_notifications':
        return m.copyWith(pushNotifications: value as bool);
      case 'email_notifications':
        return m.copyWith(emailNotifications: value as bool);
      case 'invitation_notifications':
        return m.copyWith(invitationNotifications: value as bool);
      case 'event_reminders':
        return m.copyWith(eventReminders: value as bool);
      case 'contribution_notifications':
        return m.copyWith(contributionNotifications: value as bool);
      case 'profile_visibility':
        return m.copyWith(profileVisibility: value as String);
      case 'discoverable_by_contacts':
        return m.copyWith(discoverableByContacts: value as bool);
      case 'biometric_enabled':
        return m.copyWith(biometricEnabled: value as bool);
      default:
        return m;
    }
  }

  Future<void> _onFetch(
      FetchSettings event, Emitter<UserSettingState> emit) async {
    emit(UserSettingLoading());
    final result = await repository.getSettings();
    if (result is DataSuccess<UserSettingModel>) {
      emit(UserSettingLoaded(result.data!));
    } else {
      emit(UserSettingError(_err(result)));
    }
  }

  Future<void> _onUpdate(
      UpdateSetting event, Emitter<UserSettingState> emit) async {
    if (state is! UserSettingLoaded) return;
    final current = (state as UserSettingLoaded).settings;

    // Optimistic update
    emit(UserSettingLoaded(_apply(current, event.key, event.value)));

    final result = await repository.updateSettings({event.key: event.value});
    if (result is DataSuccess<UserSettingModel>) {
      emit(UserSettingLoaded(result.data!));
    } else {
      emit(UserSettingLoaded(current));
      emit(UserSettingError(_err(result)));
    }
  }

  Future<void> _onDisableBiometric(
      DisableBiometric event, Emitter<UserSettingState> emit) async {
    if (state is! UserSettingLoaded) return;
    final current = (state as UserSettingLoaded).settings;

    // Optimistic update
    emit(UserSettingLoaded(current.copyWith(biometricEnabled: false)));

    final result = await repository.disableBiometric();
    if (result is DataSuccess<String>) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('biometric_token');
    } else {
      emit(UserSettingLoaded(current));
      emit(UserSettingError(_err(result)));
    }
  }
}
