part of 'consent_bloc.dart';

class ConsentState extends Equatable {
  const ConsentState();

  @override
  List<Object> get props => [];
}

class ConsentInitial extends ConsentState {}
class ConsentLoadingState extends ConsentState{}
class ConsentLoadedState extends ConsentState{
  final String message;

  const ConsentLoadedState({required this.message});

  @override
  List<Object> get props => [message];
}
class ConsentErrorState extends ConsentState{
  final String error;

  const ConsentErrorState({required this.error});

  @override
  List<Object> get props => [error];
}