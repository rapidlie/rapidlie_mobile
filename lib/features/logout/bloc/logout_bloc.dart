import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/logout/repository/logout_repository.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutRepository logoutRepository;
  LogoutBloc({required this.logoutRepository}) : super(LogoutInitial()) {
    on<SubmitLogoutEvent>(_onSubmitLogout);
  }

  Future<void> _onSubmitLogout(
    SubmitLogoutEvent event,
    Emitter<LogoutState> emit,
  ) async {
    emit(LogoutLoadingState());

    try {
      final result = await logoutRepository.logoutUser();

      if (result is DataSuccess<String>) {
        await UserPreferences().clearAll();

        emit(LogoutSuccessState());
      } else {
        emit(LogoutErrorState(error: "Login failed"));
      }
    } catch (e) {
      emit(LogoutErrorState(error: e.toString()));
    }
  }
}
