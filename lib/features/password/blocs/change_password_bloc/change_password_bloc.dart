import 'package:bloc/bloc.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/password/blocs/change_password_bloc/change_password_event.dart';
import 'package:rapidlie/features/password/blocs/change_password_bloc/change_password_state.dart';
import 'package:rapidlie/features/password/repositories/change_password_repository.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordRepository changePasswordRepository;
  ChangePasswordBloc({required this.changePasswordRepository})
      : super(ChangePasswordInitial()) {
    on<SubmitChangePasswordEvent>(_onSubmitChangePassword);
  }

  Future<void> _onSubmitChangePassword(
    SubmitChangePasswordEvent event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(ChangePasswordLoadingState());

    try {
      final result = await changePasswordRepository.changePassword(
        newPassword: event.newPassword,
        oldPassword: event.oldPassword,
      );

      

      if (result is DataSuccess<String>) {
       
        emit(ChangePasswordSuccessState());
      } else {
        
        emit(ChangePasswordErrorState(error: "Failed"));
      }
    } catch (e) {
      emit(ChangePasswordErrorState(error: e.toString()));
    }
  }
}
