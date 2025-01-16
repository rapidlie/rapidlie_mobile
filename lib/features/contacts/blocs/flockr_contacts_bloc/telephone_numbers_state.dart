part of 'telephone_numbers_bloc.dart';

class TelephoneNumbersState extends Equatable {
  const TelephoneNumbersState();

  @override
  List<Object> get props => [];
}

class InitialTelephoneNumbersState extends TelephoneNumbersState {}

class TelephoneNumbersLoadingState extends TelephoneNumbersState {}

class TelephoneNumbersLoaded extends TelephoneNumbersState {
  final List<dynamic> numbers;

  const TelephoneNumbersLoaded({required this.numbers});

  @override
  List<Object> get props => [numbers];
}

class TelephoneNumbersError extends TelephoneNumbersState {
  final String message;

  const TelephoneNumbersError({required this.message});

  @override
  List<Object> get props => [message];
}
