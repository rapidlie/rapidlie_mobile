import 'package:bloc/bloc.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/password/blocs/new_password_bloc/new_password_event.dart';
import 'package:rapidlie/features/password/blocs/new_password_bloc/new_password_state.dart';
import 'package:rapidlie/features/password/repositories/new_password_repository.dart';

class NewPasswordBloc extends Bloc<NewPasswordEvent, NewPasswordState> {
  final NewPasswordRepository newPasswordRepository;
  NewPasswordBloc({required this.newPasswordRepository})
      : super(NewPasswordInitial()) {
    on<SubmitNewPasswordEvent>(_onSubmitNewPassword);
  }

  Future<void> _onSubmitNewPassword(
    SubmitNewPasswordEvent event,
    Emitter<NewPasswordState> emit,
  ) async {
    emit(NewPasswordLoadingState());

    try {
      final result = await newPasswordRepository.newPassword(
        email: event.email,
        otp: event.otp,
        password: event.password,
      );

      print(result.data);
      print(result);

      if (result is DataSuccess<String>) {
        print("Yes my state got emitted");
        emit(NewPasswordSuccessState());
      } else {
        print("No my didn't emitted");
        emit(NewPasswordErrorState(error: "Login failed"));
      }
    } catch (e) {
      emit(NewPasswordErrorState(error: e.toString()));
    }
  }
}
