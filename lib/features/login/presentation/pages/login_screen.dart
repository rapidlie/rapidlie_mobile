import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/core/widgets/textfield_template.dart';
import 'package:rapidlie/features/login/bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  String token = '';
  String userName = '';
  bool obscureText = true;

  @override
  void initState() {
    emailController = new TextEditingController();
    passwordController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CustomColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is LoginSuccessState) {
              // Registration was successful
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Login Successful')),
              );

              context.go('/bottom_nav', extra: 0);
            } else if (state is LoginErrorState) {
              // Registration failed
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Login Failed: ${state.error}')),
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
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Welcome back!",
                        style: mainAppbarTitleStyle(),
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
                      extraSmallHeight(),
                      TextFieldTemplate(
                        hintText: "Password",
                        controller: passwordController,
                        obscureText: obscureText,
                        width: width,
                        height: 50,
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        enabled: true,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          child: Icon(
                            obscureText ? Icons.lock : Icons.lock_open,
                            color: CustomColors.black,
                          ),
                        ),
                      ),
                      textBoxSpace(),
                      SizedBox(
                        width: width,
                        child: GestureDetector(
                          onTap: () {
                            /* Navigator.pushNamed(
                              context,
                              RequestResetPasswordScreen.routeName,
                            ); */
                            context.push(
                              '/request_password_reset',
                            );
                          },
                          child: Text(
                            "Forgot Password?",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.inter(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      ButtonTemplate(
                        buttonName: "Login",
                        buttonWidth: width,
                        buttonAction: () {
                          BlocProvider.of<LoginBloc>(context).add(
                            SubmitLoginEvent(
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                          );
                        },
                        loading: state is LoginLoadingState,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push(
                        '/register',
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.inter(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          " Register",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.inter(
                            fontSize: 14.0,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
