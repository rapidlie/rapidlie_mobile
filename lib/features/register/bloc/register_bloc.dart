import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/register/repository/register_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository registerRepository;

  RegisterBloc({required this.registerRepository})
      : super(RegisterInitialState()) {
    on<SubmitRegisterEvent>(_onSubmitRegister);
  }

  Future<void> _onSubmitRegister(
    SubmitRegisterEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoadingState());

    try {
      final result = await registerRepository.registerUser(
        name: event.name,
        email: event.email,
        password: event.password,
        phone: event.phone,
        countryCode: event.countryCode,
      );

      if (result is DataSuccess) {
        await UserPreferences().setLoginStatus(true);
        await UserPreferences().setUserEmail(result.data!.user.email);
        await UserPreferences().setUserId(result.data!.user.uuid);
        await UserPreferences().setRegistrationStep("partial");
        emit(RegisterSuccessState());
      } else if (result is DataFailed) {
        print("Error from server: ${result.error!.message}");
        emit(RegisterErrorState(error: result.error.toString()));
      } else {
        emit(RegisterErrorState(error: "Unknown error occurred"));
      }
    } catch (e) {
      emit(RegisterErrorState(error: e.toString()));
    }
  }
}
