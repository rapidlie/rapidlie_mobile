

import 'package:equatable/equatable.dart';

class RequestState extends Equatable {
  const RequestState();

  @override
  List<Object> get props => [];
}

class RequestInitial extends RequestState {}
class RequestLoadingState extends RequestState {}

class RequestSuccessState extends RequestState {
  const RequestSuccessState();
}

class RequestErrorState extends RequestState {
  final String error;

  const RequestErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
