part of 'reel_bloc.dart';

abstract class ReelState extends Equatable {
  const ReelState();
  @override
  List<Object?> get props => [];
}

class ReelInitial extends ReelState {}

class ReelLoading extends ReelState {}

class ReelUploading extends ReelState {}

class ReelsLoaded extends ReelState {
  final List<ReelModel> reels;
  const ReelsLoaded(this.reels);
  @override
  List<Object?> get props => [reels];
}

class ReelUploadSuccess extends ReelState {
  final ReelModel reel;
  const ReelUploadSuccess(this.reel);
  @override
  List<Object?> get props => [reel];
}

class ReelDeleteSuccess extends ReelState {
  final String reelId;
  const ReelDeleteSuccess(this.reelId);
  @override
  List<Object?> get props => [reelId];
}

class ReelLikeToggled extends ReelState {
  final String reelId;
  final bool isLiked;
  const ReelLikeToggled({required this.reelId, required this.isLiked});
  @override
  List<Object?> get props => [reelId, isLiked];
}

class ReelError extends ReelState {
  final String message;
  const ReelError(this.message);
  @override
  List<Object?> get props => [message];
}
