part of 'telephone_numbers_bloc.dart';

class TelephoneNumbersEvent extends Equatable {
  const TelephoneNumbersEvent();

  @override
  List<Object> get props => [];
}

class GetNumbers extends TelephoneNumbersEvent {
  const GetNumbers();
}
