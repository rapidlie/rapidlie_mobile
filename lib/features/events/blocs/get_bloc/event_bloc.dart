import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/features/events/repository/event_respository.dart';

part 'event_event.dart';
part 'event_state.dart';

enum _EventFetchType { public, private, invited, upcoming, byCategory }

/// Shared base bloc — all 5 event-list BLoCs extend this.
abstract class _EventListBase extends Bloc<EventEvent, EventListState> {
  final EventRepository eventRepository;
  final _EventFetchType _type;

  List<EventDataModel>? _cached;
  DateTime? _cacheTimestamp;
  static const _cacheDuration = Duration(seconds: 10);

  _EventListBase(this.eventRepository, this._type)
      : super(EventListInitial()) {
    on<FetchEventList>(_onFetch);
  }

  void invalidateCache() {
    _cached = null;
    _cacheTimestamp = null;
  }

  void _invalidate() => invalidateCache();

  Future<void> _onFetch(
    FetchEventList event,
    Emitter<EventListState> emit,
  ) async {
    emit(EventListLoading());

    final now = DateTime.now();
    if (_cached != null && _cacheTimestamp != null) {
      if (now.difference(_cacheTimestamp!) < _cacheDuration) {
        emit(EventListLoaded(events: _cached!));
        return;
      } else {
        _invalidate();
      }
    }

    try {
      final result = await _fetch(event.categoryId);
      if (result is DataSuccess<List<EventDataModel>>) {
        _cached = result.data;
        _cacheTimestamp = now;
        emit(EventListLoaded(events: result.data!));
      } else if (result is DataFailed) {
        emit(EventListError(message: result.error.toString()));
      }
    } catch (e) {
      emit(EventListError(message: e.toString()));
    }
  }

  Future<DataState<List<EventDataModel>>> _fetch(String? categoryId) {
    switch (_type) {
      case _EventFetchType.public:
        return eventRepository.getPublicEvents();
      case _EventFetchType.private:
        return eventRepository.getPrivateEvents();
      case _EventFetchType.invited:
        return eventRepository.getInvitedEvents();
      case _EventFetchType.upcoming:
        return eventRepository.getUpcomingEvents();
      case _EventFetchType.byCategory:
        return eventRepository.getEventsByCategory(categoryId ?? '');
    }
  }
}

class PublicEventBloc extends _EventListBase {
  PublicEventBloc({required EventRepository eventRepository})
      : super(eventRepository, _EventFetchType.public);
}

class PrivateEventBloc extends _EventListBase {
  PrivateEventBloc({required EventRepository eventRepository})
      : super(eventRepository, _EventFetchType.private);
}

class InvitedEventBloc extends _EventListBase {
  InvitedEventBloc({required EventRepository eventRepository})
      : super(eventRepository, _EventFetchType.invited);
}

class UpcomingEventBloc extends _EventListBase {
  UpcomingEventBloc({required EventRepository eventRepository})
      : super(eventRepository, _EventFetchType.upcoming);
}

class EventByCategoryBloc extends _EventListBase {
  EventByCategoryBloc({required EventRepository eventRepository})
      : super(eventRepository, _EventFetchType.byCategory);
}
