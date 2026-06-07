part of 'sage_bloc.dart';

abstract class SageState extends Equatable {
  const SageState();
  @override
  List<Object?> get props => [];
}

class SageInitial extends SageState {}

class SageLoading extends SageState {}

class SageLoaded extends SageState {
  final SageSuggestions suggestions;
  const SageLoaded(this.suggestions);
  @override
  List<Object?> get props => [suggestions];
}

class SageError extends SageState {
  final String message;
  const SageError(this.message);
  @override
  List<Object?> get props => [message];
}
