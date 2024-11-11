import 'package:equatable/equatable.dart';

class UnlikeEventState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialUnlikeEventState extends UnlikeEventState {}

class UnlikeEventLoading extends UnlikeEventState {}

class UnlikeEventLoaded extends UnlikeEventState {
  UnlikeEventLoaded();
}

class UnlikeEventError extends UnlikeEventState {
  final String message;

  UnlikeEventError({required this.message});

  @override
  List<Object> get props => [message];
}
