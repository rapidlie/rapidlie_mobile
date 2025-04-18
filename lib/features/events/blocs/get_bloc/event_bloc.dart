import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/features/events/repository/event_respository.dart';

part 'event_event.dart';
part 'event_state.dart';

/** Public Events Bloc */
class PublicEventBloc extends Bloc<EventEvent, PublicEventState> {
  final EventRepository eventRepository;
  List<EventDataModel>? _cachedPublicEvents;
  DateTime? _cacheTimestamp;
  final Duration cacheDuration = Duration(minutes: 2);

  void invalidateCache() {
    _cachedPublicEvents = null;
    _cacheTimestamp = null;
  }

  PublicEventBloc({required this.eventRepository})
      : super(InitialPublicEventState()) {
    on<GetPublicEvents>(_onGetPublicEvents);
  }

  Future<void> _onGetPublicEvents(
    GetPublicEvents event,
    Emitter<EventState> emit,
  ) async {
    await _onGetEvents(emit, eventRepository.getPublicEvents, 'public');
  }

  Future<void> _onGetEvents(
    emit,
    Future<DataState<List<EventDataModel>>> Function() fetchFunction,
    String eventType,
  ) async {
    emit(PublicEventLoading());
    final now = DateTime.now();
    if (_cachedPublicEvents != null && _cacheTimestamp != null) {
      if (now.difference(_cacheTimestamp!) < cacheDuration) {
        emit(PublicEventLoaded(events: _cachedPublicEvents!));
        return;
      } else {
        invalidateCache();
      }
    }

    try {
      final eventResponse = await fetchFunction();

      if (eventResponse is DataSuccess<List<EventDataModel>>) {
        _cachedPublicEvents = eventResponse.data;
        _cacheTimestamp = now;
        emit(
          PublicEventLoaded(events: eventResponse.data!),
        );
      } else if (eventResponse is DataFailed) {
        emit(PublicEventError(message: eventResponse.error.toString()));
      }
    } catch (e) {
      emit(PublicEventError(message: e.toString()));
    }
  }
}

/** Invited Events Bloc */
class InvitedEventBloc extends Bloc<EventEvent, InvitedEventState> {
  final EventRepository eventRepository;
  List<EventDataModel>? _cachedInvitedEvents;
  DateTime? _cacheTimestamp;
  final Duration cacheDuration = Duration(minutes: 2);

  void invalidateCache() {
    _cachedInvitedEvents = null;
    _cacheTimestamp = null;
  }

  InvitedEventBloc({required this.eventRepository})
      : super(InitialInvitedEventState()) {
    on<GetInvitedEvents>(_onGetInvitedEvents);
  }

  Future<void> _onGetInvitedEvents(
    GetInvitedEvents event,
    Emitter<EventState> emit,
  ) async {
    await _onGetEvents(emit, eventRepository.getInvitedEvents, 'public');
  }

  Future<void> _onGetEvents(
    emit,
    Future<DataState<List<EventDataModel>>> Function() fetchFunction,
    String eventType,
  ) async {
    emit(InvitedEventLoading());
    final now = DateTime.now();
    if (_cachedInvitedEvents != null && _cacheTimestamp != null) {
      if (now.difference(_cacheTimestamp!) < cacheDuration) {
        emit(InvitedEventLoaded(events: _cachedInvitedEvents!));
        return;
      } else {
        invalidateCache();
      }
    }

    try {
      final eventResponse = await fetchFunction();

      if (eventResponse is DataSuccess<List<EventDataModel>>) {
        _cachedInvitedEvents = eventResponse.data;
        _cacheTimestamp = now;
        emit(
          InvitedEventLoaded(events: eventResponse.data!),
        );
      } else if (eventResponse is DataFailed) {
        emit(InvitedEventError(message: eventResponse.error.toString()));
      }
    } catch (e) {
      emit(InvitedEventError(message: e.toString()));
    }
  }
}

/** Private Event Bloc **/
class PrivateEventBloc extends Bloc<EventEvent, PrivateEventState> {
  final EventRepository eventRepository;
  List<EventDataModel>? _cachedPrivateEvents;
  DateTime? _cacheTimestamp;
  final Duration cacheDuration = Duration(minutes: 2);

  void invalidateCache() {
    _cachedPrivateEvents = null;
    _cacheTimestamp = null;
  }

  PrivateEventBloc({required this.eventRepository})
      : super(InitialPrivateEventState()) {
    on<GetPrivateEvents>(_onGetPrivateEvents);
  }

  Future<void> _onGetPrivateEvents(
    GetPrivateEvents event,
    Emitter<PrivateEventState> emit,
  ) async {
    await _onGetEvents(emit, eventRepository.getPrivateEvents);
  }

  Future<void> _onGetEvents(
    Emitter<PrivateEventState> emit,
    Future<DataState<List<EventDataModel>>> Function() fetchFunction,
  ) async {
    emit(PrivateEventLoading());

    final now = DateTime.now();

    // Check if cache is valid
    if (_cachedPrivateEvents != null && _cacheTimestamp != null) {
      if (now.difference(_cacheTimestamp!) < cacheDuration) {
        emit(PrivateEventLoaded(events: _cachedPrivateEvents!));
        return;
      } else {
        invalidateCache();
      }
    }

    try {
      final eventResponse = await fetchFunction();

      if (eventResponse is DataSuccess<List<EventDataModel>>) {
        _cachedPrivateEvents = eventResponse.data;
        _cacheTimestamp = now;
        emit(
          PrivateEventLoaded(events: eventResponse.data!),
        );
      } else if (eventResponse is DataFailed) {
        emit(PrivateEventError(message: eventResponse.error.toString()));
      }
    } catch (e) {
      emit(PrivateEventError(message: e.toString()));
    }
  }
}

/** Upcoming Events Bloc */
class UpcomingEventBloc extends Bloc<EventEvent, UpcomingEventState> {
  final EventRepository eventRepository;
  List<EventDataModel>? _cachedUpcomingEvents;
  DateTime? _cacheTimestamp;
  final Duration cacheDuration = Duration(minutes: 2);

  void invalidateCache() {
    _cachedUpcomingEvents = null;
    _cacheTimestamp = null;
  }

  UpcomingEventBloc({required this.eventRepository})
      : super(InitialUpcomingEventState()) {
    on<GetUpcomingEvents>(_onGetUpcomingEvents);
  }

  Future<void> _onGetUpcomingEvents(
    GetUpcomingEvents event,
    Emitter<EventState> emit,
  ) async {
    await _onGetEvents(emit, eventRepository.getUpcomingEvents);
  }

  Future<void> _onGetEvents(
    emit,
    Future<DataState<List<EventDataModel>>> Function() fetchFunction,
  ) async {
    emit(UpcomingEventLoading());
    final now = DateTime.now();

    // Check if cache is valid
    if (_cachedUpcomingEvents != null && _cacheTimestamp != null) {
      if (now.difference(_cacheTimestamp!) < cacheDuration) {
        emit(UpcomingEventLoaded(events: _cachedUpcomingEvents!));
        return;
      } else {
        invalidateCache();
      }
    }

    try {
      final eventResponse = await fetchFunction();

      if (eventResponse is DataSuccess<List<EventDataModel>>) {
        _cachedUpcomingEvents = eventResponse.data;
        _cacheTimestamp = now;
        emit(
          UpcomingEventLoaded(events: eventResponse.data!),
        );
      } else if (eventResponse is DataFailed) {
        emit(UpcomingEventError(message: eventResponse.error.toString()));
      }
    } catch (e) {
      emit(UpcomingEventError(message: e.toString()));
    }
  }
}

/** Events By Category Bloc */
class EventByCategoryBloc extends Bloc<EventEvent, EventByCategoryState> {
  final EventRepository eventRepository;
  List<EventDataModel>? _cachedEventsByCategory;
  DateTime? _cacheTimestamp;
  final Duration cacheDuration = Duration(minutes: 2);

  void invalidateCache() {
    _cachedEventsByCategory = null;
    _cacheTimestamp = null;
  }

  EventByCategoryBloc({required this.eventRepository})
      : super(InitialEventByCategoryState()) {
    on<GetEventsByCategory>(_onGetEventsByCategory);
  }

  Future<void> _onGetEventsByCategory(
    GetEventsByCategory event,
    Emitter<EventState> emit,
  ) async {
    await _onGetEvents(
      emit,
      () => eventRepository.getEventsByCategory(event.categoryId),
    );
  }

  Future<void> _onGetEvents(
    emit,
    Future<DataState<List<EventDataModel>>> Function() fetchFunction,
  ) async {
    emit(EventByCategoryLoading());
    final now = DateTime.now();

    // Check if cache is valid
    if (_cachedEventsByCategory != null && _cacheTimestamp != null) {
      if (now.difference(_cacheTimestamp!) < cacheDuration) {
        emit(EventByCategoryLoaded(events: _cachedEventsByCategory!));
        return;
      } else {
        invalidateCache();
      }
    }

    try {
      final eventResponse = await fetchFunction();

      if (eventResponse is DataSuccess<List<EventDataModel>>) {
        _cachedEventsByCategory = eventResponse.data;
        _cacheTimestamp = now;
        emit(
          EventByCategoryLoaded(events: eventResponse.data!),
        );
      } else if (eventResponse is DataFailed) {
        emit(EventByCategoryError(message: eventResponse.error.toString()));
      }
    } catch (e) {
      emit(EventByCategoryError(message: e.toString()));
    }
  }
}
