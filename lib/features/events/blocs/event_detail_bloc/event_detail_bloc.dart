import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/features/events/repository/event_detail_respository.dart';

part 'event_detail_event.dart';
part 'event_detail_state.dart';

class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  final EventDetailRepository eventdetailRepository;
  EventDataModel? _cachedEventDetail;
  DateTime? _cacheTimestamp;
  final Duration cacheDuration = Duration(seconds: 2);

  void invalidateCache() {
    _cachedEventDetail = null;
    _cacheTimestamp = null;
  }

  EventDetailBloc({required this.eventdetailRepository})
      : super(InitialEventDetailState()) {
    on<GetEventDetail>(_onGetEventDetail);
  }

  Future<void> _onGetEventDetail(
    GetEventDetail event,
    Emitter<EventState> emit,
  ) async {
    await _onGetEvent(
      emit,
      () => eventdetailRepository.getEventsById(event.eventId),
    );
  }

  Future<void> _onGetEvent(
    emit,
    Future<DataState<EventDataModel>> Function() fetchFunction,
  ) async {
    emit(EventDetailLoading());
    final now = DateTime.now();

    if (_cachedEventDetail != null && _cacheTimestamp != null) {
      if (now.difference(_cacheTimestamp!) < cacheDuration) {
        emit(EventDetailLoaded(events: _cachedEventDetail!));
      } else {
        invalidateCache();
      }
    }

    try {
      final eventResponse = await fetchFunction();

      if (eventResponse is DataSuccess<EventDataModel>) {
        _cachedEventDetail = eventResponse.data;
        _cacheTimestamp = now;
        emit(
          EventDetailLoaded(events: eventResponse.data!),
        );
      } else if (eventResponse is DataFailed) {
        emit(EventDetailError(message: eventResponse.error.toString()));
      }
    } catch (e) {
      emit(EventDetailError(message: e.toString()));
    }
  }
}
