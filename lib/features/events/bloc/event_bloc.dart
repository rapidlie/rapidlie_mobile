import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/features/events/repository/event_respository.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;

  EventBloc({required this.eventRepository}) : super(InitialEventState()) {
    on<GetAllEvents>(_onGetAllEvents);
    on<GetPrivateEvents>(_onGetPrivateEvents);
    on<GetPublicEvents>(_onGetPublicEvents);
    on<GetEventsByCategory>(_onGetEventsByCategory);
  }

  Future<void> _onGetAllEvents(
    GetAllEvents event,
    Emitter<EventState> emit,
  ) async {
    await _onGetEvents(emit, eventRepository.getAllEvents);
  }

  Future<void> _onGetPrivateEvents(
    GetPrivateEvents event,
    Emitter<EventState> emit,
  ) async {
    await _onGetEvents(emit, eventRepository.getPrivateEvents);
  }

  Future<void> _onGetPublicEvents(
    GetPublicEvents event,
    Emitter<EventState> emit,
  ) async {
    await _onGetEvents(emit, eventRepository.getPublicEvents);
  }

  Future<void> _onGetEventsByCategory(
    GetEventsByCategory event,
    Emitter<EventState> emit,
  ) async {
    await _onGetEvents(
        emit, () => eventRepository.getEventsByCategory(event.categoryId));
  }

  Future<void> _onGetEvents(
    Emitter<EventState> emit,
    Future<DataState<List<EventDataModel>>> Function() fetchFunction,
  ) async {
    emit(EventLoading());

    try {
      final eventResponse = await fetchFunction();

      if (eventResponse is DataSuccess<List<EventDataModel>>) {
        emit(EventLoaded(events: eventResponse.data!));
      } else if (eventResponse is DataFailed) {
        emit(EventError(message: eventResponse.error.toString()));
      }
    } catch (e) {
      emit(EventError(message: e.toString()));
    }
  }
}
