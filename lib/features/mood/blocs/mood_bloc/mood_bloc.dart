import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/features/mood/data/models/mood_model.dart';
import 'package:rapidlie/features/mood/data/repository/mood_repository.dart';

part 'mood_event.dart';
part 'mood_state.dart';

class MoodBloc extends Bloc<MoodEvent, MoodState> {
  final MoodRepository moodRepository;

  MoodBloc({required this.moodRepository}) : super(MoodInitial()) {
    on<FetchMoods>(_onFetchMoods);
    on<FetchCurrentMood>(_onFetchCurrentMood);
    on<SetMood>(_onSetMood);
    on<FetchMoodSuggestions>(_onFetchSuggestions);
  }

  Future<void> _onFetchMoods(
      FetchMoods event, Emitter<MoodState> emit) async {
    emit(MoodLoading());
    final result = await moodRepository.getMoods();
    if (result is DataSuccess<List<MoodOption>>) {
      emit(MoodOptionsLoaded(result.data!));
    } else {
      emit(MoodError('Failed to load moods'));
    }
  }

  Future<void> _onFetchCurrentMood(
      FetchCurrentMood event, Emitter<MoodState> emit) async {
    final result = await moodRepository.getCurrentMood();
    if (result is DataSuccess<String>) {
      emit(CurrentMoodLoaded(result.data!));
    }
  }

  Future<void> _onSetMood(SetMood event, Emitter<MoodState> emit) async {
    emit(MoodSetting());
    final result = await moodRepository.setMood(event.mood);
    if (result is DataSuccess<String>) {
      emit(MoodSetSuccess(result.data!));
    } else {
      emit(MoodError(
          result.error?.response?.data['message'] as String? ??
              'Failed to set mood'));
    }
  }

  Future<void> _onFetchSuggestions(
      FetchMoodSuggestions event, Emitter<MoodState> emit) async {
    emit(MoodLoading());
    final result = await moodRepository.getMoodSuggestions();
    if (result is DataSuccess<List<EventDataModel>>) {
      emit(MoodSuggestionsLoaded(result.data!));
    } else {
      emit(MoodError(
          result.error?.response?.data['message'] as String? ??
              'No suggestions available'));
    }
  }
}
