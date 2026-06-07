part of 'lens_bloc.dart';

abstract class LensState extends Equatable {
  const LensState();
  @override
  List<Object?> get props => [];
}

class LensInitial extends LensState {}

class LensLoading extends LensState {}

class LensLoaded extends LensState {
  final LensModel insights;
  const LensLoaded(this.insights);
  @override
  List<Object?> get props => [insights];
}

class LensError extends LensState {
  final String message;
  const LensError(this.message);
  @override
  List<Object?> get props => [message];
}
