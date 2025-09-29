import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/core/widgets/textfield_template.dart';
import 'package:rapidlie/features/password/blocs/request_reset_bloc/request_bloc.dart';
import 'package:rapidlie/features/password/blocs/request_reset_bloc/request_state.dart';

class RequestResetPasswordScreen extends StatefulWidget {
  static const String routeName = "request_password";
  const RequestResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<RequestResetPasswordScreen> createState() =>
      _RequestResetPasswordScreenState();
}

class _RequestResetPasswordScreenState
    extends State<RequestResetPasswordScreen> {
  late TextEditingController emailController;
  late TextEditingController otpController;
  late TextEditingController newPasswordController;

  @override
  void initState() {
    emailController = TextEditingController();
    otpController = TextEditingController();
    newPasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
          child: BlocConsumer<RequestBloc, RequestState>(
            listener: (context, state) {
              if (state is RequestErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                  ),
                );
              }
              if (state is RequestSuccessState) {
                print(emailController.text.toString());
                context.push(
                  '/new_password',
                  extra: emailController.text.toString(),
                );
              }
            },
            builder: (context, state) {
              return Container(
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
                          "Enter email to request for password reset.",
                          style: mainAppbarTitleStyle(context),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        TextFieldTemplate(
                          hintText: "Email",
                          controller: emailController,
                          obscureText: false,
                          width: width,
                          height: 50,
                          textInputType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          enabled: true,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ButtonTemplate(
                          buttonName: "Send request",
                          buttonType: ButtonType.elevated,
                          loading: state is RequestLoadingState,
                          buttonAction: () {
                            context.read<RequestBloc>().add(
                                  SubmitRequestEvent(
                                    email: emailController.text,
                                  ),
                                );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
