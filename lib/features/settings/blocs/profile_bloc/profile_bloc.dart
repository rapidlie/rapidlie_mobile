import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/settings/repositories/profile_repository.dart';
import 'package:rapidlie/features/user/models/user_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  ProfileBloc({required this.profileRepository})
      : super(ProfileInitialState()) {
    on<GetProfileEvent>(_onGetProfile);
  }

  Future<DataState<void>> _onGetProfile(
    ProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());

    try {
      final userProfile = await profileRepository.getUserProfile();
      if (userProfile is DataSuccess) {
        emit(ProfileLoadedState(userProfile: userProfile.data!));
        return userProfile;
      } else {
        emit(ProfileErrorState(error: 'Failed to load profile'));
        return DataFailed(DioException(
            error: userProfile.error!.error,
            requestOptions: userProfile.error!.requestOptions));
      }
    } catch (e) {
      emit(ProfileErrorState(error: e.toString()));
      return DataFailed(DioException(
          error: 'Failed to load profile',
          requestOptions: RequestOptions(path: '')));
    }
  }
}
