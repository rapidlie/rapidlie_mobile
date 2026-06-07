part of 'like_toggle_bloc.dart';

abstract class LikeToggleState extends Equatable {
  const LikeToggleState();
  @override
  List<Object?> get props => [];
}

class LikeToggleInitial extends LikeToggleState {}

class LikeToggleLoading extends LikeToggleState {}

class LikeToggleSuccess extends LikeToggleState {
  final bool isLiked;
  const LikeToggleSuccess({required this.isLiked});
  @override
  List<Object> get props => [isLiked];
}

class LikeToggleError extends LikeToggleState {
  final String message;
  const LikeToggleError({required this.message});
  @override
  List<Object> get props => [message];
}
