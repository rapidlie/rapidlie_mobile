import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/core/widgets/textfield_template.dart';
import 'package:rapidlie/features/login/presentation/pages/login_screen.dart';
import 'package:rapidlie/features/password/blocs/new_password_bloc/new_password_bloc.dart';
import 'package:rapidlie/features/password/blocs/new_password_bloc/new_password_event.dart';
import 'package:rapidlie/features/password/blocs/new_password_bloc/new_password_state.dart';

class NewPasswordScreen extends StatefulWidget {
  static const String routeName = "new_password";

  const NewPasswordScreen({Key? key}) : super(key: key);

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  late TextEditingController otpController;
  late TextEditingController newPasswordController;
  bool visible = false;
  bool enabled = true;

  @override
  void initState() {
    otpController = TextEditingController();
    newPasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
          child: Container(
            height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                        ),
                      ),
                    ),
                    Text(
                      "Enter the code sent to your email and a new password.",
                      style: mainAppbarTitleStyle(),
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextFieldTemplate(
                      hintText: "Otp",
                      controller: otpController,
                      obscureText: false,
                      width: width,
                      height: 50,
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      enabled: true,
                    ),
                    textBoxSpace(),
                    TextFieldTemplate(
                      hintText: "New password",
                      controller: newPasswordController,
                      obscureText: false,
                      width: width,
                      height: 50,
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      enabled: true,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    BlocListener<NewPasswordBloc, NewPasswordState>(
                      listener: (context, state) {
                        if (state is NewPasswordSuccessState) {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                        }
                      },
                      child: ButtonTemplate(
                        buttonName: "Change password",
                        buttonWidth: width,
                        buttonAction: () {
                          context.read<NewPasswordBloc>().add(
                                SubmitNewPasswordEvent(
                                  email: email,
                                  otp: otpController.text,
                                  password: newPasswordController.text,
                                ),
                              );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
