part of 'create_event_bloc.dart';

class CreateEventState extends Equatable {
  const CreateEventState();

  @override
  List<Object> get props => [];
}

class InitialCreateEventState extends CreateEventState {}

class CreateEventLoading extends CreateEventState {}

class CreateEventSuccessful extends CreateEventState {
 

  const CreateEventSuccessful();

  @override
  List<Object> get props => [];
}

class CreateEventError extends CreateEventState {
  final String message;

  const CreateEventError({required this.message});

  @override
  List<Object> get props => [message];
}
