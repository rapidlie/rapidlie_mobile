import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/bookmarks/data/bookmark_repository.dart';
import 'package:rapidlie/features/events/models/event_model.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final BookmarkRepository bookmarkRepository;

  BookmarkBloc({required this.bookmarkRepository}) : super(BookmarkInitial()) {
    on<ToggleBookmark>(_onToggle);
    on<FetchBookmarkedEvents>(_onFetch);
  }

  Future<void> _onToggle(
    ToggleBookmark event,
    Emitter<BookmarkState> emit,
  ) async {
    emit(BookmarkLoading());
    final result = event.bookmark
        ? await bookmarkRepository.bookmarkEvent(event.eventId)
        : await bookmarkRepository.removeBookmark(event.eventId);

    if (result is DataSuccess) {
      emit(BookmarkToggleSuccess(isBookmarked: event.bookmark));
    } else {
      emit(BookmarkError(
          message: (result as DataFailed).error?.message ?? 'Failed'));
    }
  }

  Future<void> _onFetch(
    FetchBookmarkedEvents event,
    Emitter<BookmarkState> emit,
  ) async {
    emit(BookmarkLoading());
    final result = await bookmarkRepository.getBookmarkedEvents();
    if (result is DataSuccess<List<EventDataModel>>) {
      emit(BookmarkedEventsLoaded(events: result.data!));
    } else {
      emit(BookmarkError(
          message: (result as DataFailed).error?.message ?? 'Failed'));
    }
  }
}
