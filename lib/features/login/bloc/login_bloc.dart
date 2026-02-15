/* import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/login/models/login_model.dart';
import 'package:rapidlie/features/login/repository/login_repository.dart';

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
        emit(LoginSuccessState(loginResponse: result.data!));
      } else {
        emit(LoginErrorState(error: "Login failed"));
      }
    } catch (e) {
      emit(LoginErrorState(error: e.toString()));
    }
  }
}
 */


import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/login/models/login_model.dart';
import 'package:rapidlie/features/login/repository/login_repository.dart';

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

    final result = await loginRepository.loginUser(
      email: event.email,
      password: event.password,
    );

    if (result is DataSuccess<LoginResponse>) {
      emit(LoginSuccessState(loginResponse: result.data!));
      return;
    }

    if (result is DataFailed) {
      final err = result.error;

      if (err is DioException) {
        // ✅ Use the clean message we stored in repository
        emit(LoginErrorState(
          error: err.error?.toString() ?? "Login failed",
        ));
      } else {
        emit(LoginErrorState(error: err.toString()));
      }
      return;
    }

    emit(const LoginErrorState(error: "Login failed"));
  }
}