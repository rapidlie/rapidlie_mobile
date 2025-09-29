import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/events/repository/create_event_repository.dart';

part 'create_event_event.dart';
part 'create_event_state.dart';

class CreateEventBloc extends Bloc<CreateEventEvent, CreateEventState> {
  final CreateEventRepository createEventRepository;

  CreateEventBloc(this.createEventRepository)
      : super(InitialCreateEventState()) {
    on<CreateEventEvent>(_onCreateEvent);
    on<ResetCreateEvent>(_onResetCreateEvent);
  }

  Future<void> _onCreateEvent(
      CreateEventEvent event, Emitter<CreateEventState> emit) async {
    emit(CreateEventLoading());

    try {
      if (event is SubmitCreateEventEvent) {
        final createEventResponse = await createEventRepository.createEvent(
          image: event.image,
          name: event.name,
          eventType: event.eventType,
          category: event.category,
          description: event.description,
          date: event.date,
          startTime: event.startTime,
          endTime: event.endTime,
          venue: event.venue,
          mapLocation: event.mapLocation,
          guests: event.guests ?? [],
        );

        if (createEventResponse is DataSuccess) {
          emit(CreateEventSuccessful());
        } else if (createEventResponse is DataFailed) {
          emit(CreateEventError(message: createEventResponse.error.toString()));
        }
      }
    } catch (e) {
      emit(CreateEventError(message: e.toString()));
    }
  }

  void _onResetCreateEvent(
    ResetCreateEvent event,
    Emitter<CreateEventState> emit,
  ) {
    emit(InitialCreateEventState()); // Emit the initial state
  }
}
