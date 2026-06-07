import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/lens/data/models/lens_model.dart';
import 'package:rapidlie/features/lens/data/repository/lens_repository.dart';

part 'lens_event.dart';
part 'lens_state.dart';

class LensBloc extends Bloc<LensEvent, LensState> {
  final LensRepository lensRepository;

  LensBloc({required this.lensRepository}) : super(LensInitial()) {
    on<FetchInsights>(_onFetch);
  }

  Future<void> _onFetch(FetchInsights event, Emitter<LensState> emit) async {
    emit(LensLoading());
    final result = await lensRepository.getInsights(event.eventId);
    if (result is DataSuccess<LensModel>) {
      emit(LensLoaded(result.data!));
    } else {
      emit(LensError(result.error?.response?.data['message'] as String? ??
          'Failed to load insights'));
    }
  }
}
