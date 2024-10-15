import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/features/events/repository/event_respository.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;

  EventBloc({required this.eventRepository})
      : super(InitialEventState(eventType: 'initial')) {
    on<GetPrivateEvents>(_onGetPrivateEvents);
    on<GetPublicEvents>(_onGetPublicEvents);
    on<GetEventsByCategory>(_onGetEventsByCategory);
    on<GetUpcomingEvents>(_onGetUpcomingEvents);
  }

  Future<void> _onGetPrivateEvents(
    GetPrivateEvents event,
    Emitter<EventState> emit,
  ) async {
    await _onGetEvents(emit, eventRepository.getPrivateEvents, 'private');
  }

  Future<void> _onGetPublicEvents(
    GetPublicEvents event,
    Emitter<EventState> emit,
  ) async {
    await _onGetEvents(emit, eventRepository.getPublicEvents, 'public');
  }

  Future<void> _onGetUpcomingEvents(
    GetUpcomingEvents event,
    Emitter<EventState> emit,
  ) async {
    await _onGetEvents(emit, eventRepository.getUpcomingEvents, 'upcoming');
  }

  Future<void> _onGetEventsByCategory(
    GetEventsByCategory event,
    Emitter<EventState> emit,
  ) async {
    await _onGetEvents(
        emit,
        () => eventRepository.getEventsByCategory(event.categoryId),
        'category');
  }

  Future<void> _onGetEvents(
    Emitter<EventState> emit,
    Future<DataState<List<EventDataModel>>> Function() fetchFunction,
    String eventType,
  ) async {
    emit(EventLoading(eventType: eventType));

    try {
      final eventResponse = await fetchFunction();

      if (eventResponse is DataSuccess<List<EventDataModel>>) {
        emit(
          EventLoaded(events: eventResponse.data!, eventType: eventType),
        );
      } else if (eventResponse is DataFailed) {
        emit(EventError(
            message: eventResponse.error.toString(), eventType: eventType));
      }
    } catch (e) {
      emit(EventError(message: e.toString(), eventType: eventType));
    }
  }
}
