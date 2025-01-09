part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final UserModel userProfile;
  ProfileLoadedState({required this.userProfile});
}

class ProfileErrorState extends ProfileState {
  final String error;

  const ProfileErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
