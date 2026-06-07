part of 'mood_bloc.dart';

abstract class MoodState extends Equatable {
  const MoodState();
  @override
  List<Object?> get props => [];
}

class MoodInitial extends MoodState {}

class MoodLoading extends MoodState {}

class MoodSetting extends MoodState {}

class MoodOptionsLoaded extends MoodState {
  final List<MoodOption> moods;
  const MoodOptionsLoaded(this.moods);
  @override
  List<Object?> get props => [moods];
}

class CurrentMoodLoaded extends MoodState {
  final String mood;
  const CurrentMoodLoaded(this.mood);
  @override
  List<Object?> get props => [mood];
}

class MoodSetSuccess extends MoodState {
  final String mood;
  const MoodSetSuccess(this.mood);
  @override
  List<Object?> get props => [mood];
}

class MoodSuggestionsLoaded extends MoodState {
  final List<EventDataModel> events;
  const MoodSuggestionsLoaded(this.events);
  @override
  List<Object?> get props => [events];
}

class MoodError extends MoodState {
  final String message;
  const MoodError(this.message);
  @override
  List<Object?> get props => [message];
}
