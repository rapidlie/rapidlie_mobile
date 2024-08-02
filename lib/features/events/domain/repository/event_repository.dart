import 'package:rapidlie/core/resources/data_state.dart';
import 'package:rapidlie/features/events/domain/entities/event_entity.dart';

abstract class EventRepository {
  Future<DataState<List<EventEntity>>> getEventEntries();
}
