import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/sage/data/models/sage_model.dart';
import 'package:rapidlie/features/sage/data/repository/sage_repository.dart';

part 'sage_event.dart';
part 'sage_state.dart';

class SageBloc extends Bloc<SageEvent, SageState> {
  final SageRepository sageRepository;

  SageBloc({required this.sageRepository}) : super(SageInitial()) {
    on<FetchSageSuggestions>(_onFetch);
  }

  Future<void> _onFetch(
      FetchSageSuggestions event, Emitter<SageState> emit) async {
    emit(SageLoading());
    final result = await sageRepository.getSuggestions(
      eventId: event.eventId,
      question: event.question,
    );
    if (result is DataSuccess<SageSuggestions>) {
      emit(SageLoaded(result.data!));
    } else {
      emit(SageError(result.error?.response?.data['message'] as String? ??
          'SAGE is temporarily unavailable.'));
    }
  }
}
