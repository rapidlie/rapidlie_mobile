part of 'reel_bloc.dart';

abstract class ReelEvent extends Equatable {
  const ReelEvent();
  @override
  List<Object?> get props => [];
}

class FetchReels extends ReelEvent {
  final String eventId;
  const FetchReels(this.eventId);
  @override
  List<Object?> get props => [eventId];
}

class PostReel extends ReelEvent {
  final String eventId;
  final String mediaUrl;
  final String mediaType;
  final String? caption;
  const PostReel({
    required this.eventId,
    required this.mediaUrl,
    required this.mediaType,
    this.caption,
  });
  @override
  List<Object?> get props => [eventId, mediaUrl, mediaType, caption];
}

class DeleteReel extends ReelEvent {
  final String reelId;
  const DeleteReel(this.reelId);
  @override
  List<Object?> get props => [reelId];
}

class ToggleReelLike extends ReelEvent {
  final String reelId;
  final bool like;
  const ToggleReelLike({required this.reelId, required this.like});
  @override
  List<Object?> get props => [reelId, like];
}
