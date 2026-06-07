part of 'bookmark_bloc.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();
  @override
  List<Object?> get props => [];
}

class ToggleBookmark extends BookmarkEvent {
  final String eventId;
  final bool bookmark;
  const ToggleBookmark({required this.eventId, required this.bookmark});
  @override
  List<Object> get props => [eventId, bookmark];
}

class FetchBookmarkedEvents extends BookmarkEvent {
  const FetchBookmarkedEvents();
}
