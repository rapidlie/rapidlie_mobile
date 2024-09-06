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
    on<GetEvents>(_onGetEvent);
  }

  Future<void> _onGetEvent(GetEvents event, Emitter<EventState> emit) async {
    emit(EventLoading());

    try {
      final eventResponse = await eventRepository.getEventEntries();

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
