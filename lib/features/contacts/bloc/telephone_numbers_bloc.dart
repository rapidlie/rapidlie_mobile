import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/contacts/repository/telephone_numbers_repository.dart';

part 'telephone_numbers_event.dart';
part 'telephone_numbers_state.dart';

class TelephoneNumbersBloc
    extends Bloc<TelephoneNumbersEvent, TelephoneNumbersState> {
  final TelephoneNumbersRepository telephoneNumbersRepository;
  TelephoneNumbersBloc({required this.telephoneNumbersRepository})
      : super(InitialTelephoneNumbersState()) {
    on<GetNumbers>(_onGetNumbers);
  }

  Future<void> _onGetNumbers(
      GetNumbers event, Emitter<TelephoneNumbersState> emit) async {
    emit(TelephoneNumbersLoadingState());

    try {
      final numbersResponse = await telephoneNumbersRepository.getNumbers();

      if (numbersResponse is DataSuccess<dynamic>) {
        emit(TelephoneNumbersLoaded(numbers: numbersResponse.data!));
      } else if (numbersResponse is DataFailed) {
        emit(TelephoneNumbersError(message: numbersResponse.error.toString()));
      }
    } catch (e) {
      emit(TelephoneNumbersError(message: e.toString()));
    }
  }
}
