part of 'mood_bloc.dart';

abstract class MoodEvent extends Equatable {
  const MoodEvent();
  @override
  List<Object?> get props => [];
}

class FetchMoods extends MoodEvent {
  const FetchMoods();
}

class FetchCurrentMood extends MoodEvent {
  const FetchCurrentMood();
}

class SetMood extends MoodEvent {
  final String mood;
  const SetMood(this.mood);
  @override
  List<Object?> get props => [mood];
}

class FetchMoodSuggestions extends MoodEvent {
  const FetchMoodSuggestions();
}
