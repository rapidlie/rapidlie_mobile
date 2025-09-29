import 'package:equatable/equatable.dart';

class LikeEventState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialLikeEventState extends LikeEventState {}

class LikeEventLoading extends LikeEventState {}

class LikeEventLoaded extends LikeEventState {
  final bool isLiked;

  LikeEventLoaded({required this.isLiked});

  @override
  List<Object> get props => [isLiked];
}

class LikeEventError extends LikeEventState {
  final String message;

  LikeEventError({required this.message});

  @override
  List<Object> get props => [message];
}
