part of 'announce_bloc.dart';

abstract class AnnounceState extends Equatable {
  const AnnounceState();
  @override
  List<Object?> get props => [];
}

class AnnounceInitial extends AnnounceState {}

class AnnounceLoading extends AnnounceState {}

class AnnounceSuccess extends AnnounceState {
  final String message;
  const AnnounceSuccess(this.message);
  @override
  List<Object> get props => [message];
}

class AnnounceError extends AnnounceState {
  final String message;
  const AnnounceError({required this.message});
  @override
  List<Object> get props => [message];
}
