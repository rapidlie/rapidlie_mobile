import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/password/blocs/request_reset_bloc/request_state.dart';
import 'package:rapidlie/features/password/repositories/request_repository.dart';

part 'request_event.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final RequestRepository requestRepository;
  RequestBloc({required this.requestRepository}) : super(RequestInitial()) {
    on<SubmitRequestEvent>(_onSubmitRequest);
  }

  Future<void> _onSubmitRequest(
    SubmitRequestEvent event,
    Emitter<RequestState> emit,
  ) async {
    emit(RequestLoadingState());

    try {
      final result = await requestRepository.requestReset(
        email: event.email,
      );

      print(result.error);

      if (result is DataSuccess<String>) {
        emit(RequestSuccessState());
      } else {
        emit(RequestErrorState(
            error: "An error occurred, please check email and try again."));gi co
      }
    } catch (e) {
      emit(RequestErrorState(error: e.toString()));
    }
  }
}
