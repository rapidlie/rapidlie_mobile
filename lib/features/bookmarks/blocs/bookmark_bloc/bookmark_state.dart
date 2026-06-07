part of 'bookmark_bloc.dart';

abstract class BookmarkState extends Equatable {
  const BookmarkState();
  @override
  List<Object?> get props => [];
}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoading extends BookmarkState {}

class BookmarkToggleSuccess extends BookmarkState {
  final bool isBookmarked;
  const BookmarkToggleSuccess({required this.isBookmarked});
  @override
  List<Object> get props => [isBookmarked];
}

class BookmarkedEventsLoaded extends BookmarkState {
  final List<EventDataModel> events;
  const BookmarkedEventsLoaded({required this.events});
  @override
  List<Object> get props => [events];
}

class BookmarkError extends BookmarkState {
  final String message;
  const BookmarkError({required this.message});
  @override
  List<Object> get props => [message];
}
