import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/login/models/login_model.dart';
import 'package:rapidlie/features/login/repository/login_repository.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc({required this.loginRepository}) : super(LoginInitialState()) {
    on<SubmitLoginEvent>(_onSubmitLogin);
  }

  Future<void> _onSubmitLogin(
    SubmitLoginEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoadingState());

    try {
      final result = await loginRepository.loginUser(
        email: event.email,
        password: event.password,
      );

      if (result is DataSuccess<LoginResponse>) {
        UserPreferences().setBearerToken(result.data!.accessToken);
        UserPreferences().setUserName(result.data!.user.name);
        UserPreferences().setLoginStatus(true);
        emit(LoginSuccessState(loginResponse: result.data!));
      } else {
        emit(LoginErrorState(error: "Login failed"));
      }
    } catch (e) {
      emit(LoginErrorState(error: e.toString()));
    }
  }
}
