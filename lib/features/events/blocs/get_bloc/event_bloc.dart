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

    try {
      final eventResponse = await fetchFunction();

      if (eventResponse is DataSuccess<List<EventDataModel>>) {
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

/** Public Events Bloc */
class InvitedEventBloc extends Bloc<EventEvent, InvitedEventState> {
  final EventRepository eventRepository;

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

    try {
      final eventResponse = await fetchFunction();

      if (eventResponse is DataSuccess<List<EventDataModel>>) {
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

  PrivateEventBloc({required this.eventRepository})
      : super(InitialPrivateEventState()) {
    on<GetPrivateEvents>(_onGetPrivateEvents);
  }

  Future<void> _onGetPrivateEvents(
    GetPrivateEvents event,
    Emitter<EventState> emit,
  ) async {
    await _onGetEvents(emit, eventRepository.getPrivateEvents);
  }

  Future<void> _onGetEvents(
    emit,
    Future<DataState<List<EventDataModel>>> Function() fetchFunction,
  ) async {
    emit(PrivateEventLoading());

    try {
      final eventResponse = await fetchFunction();

      if (eventResponse is DataSuccess<List<EventDataModel>>) {
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

    try {
      final eventResponse = await fetchFunction();

      if (eventResponse is DataSuccess<List<EventDataModel>>) {
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

  EventByCategoryBloc({required this.eventRepository})
      : super(InitialEventByCategoryState()) {
    on<GetEventsByCategory>(_onGetEventsByCategory);
  }

  Future<void> _onGetEventsByCategory(
    GetEventsByCategory event,
    Emitter<EventState> emit,
  ) async {
    await _onGetEvents(
        emit, () => eventRepository.getEventsByCategory(event.categoryId));
  }

  Future<void> _onGetEvents(
    emit,
    Future<DataState<List<EventDataModel>>> Function() fetchFunction,
  ) async {
    emit(EventByCategoryLoading());

    try {
      final eventResponse = await fetchFunction();

      if (eventResponse is DataSuccess<List<EventDataModel>>) {
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
