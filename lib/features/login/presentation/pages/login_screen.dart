import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/color_constants.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/core/widgets/text_field_template.dart';
import 'package:rapidlie/features/forgot_password/presentation/pages/forgot_password_screen.dart';

import '../../../register/presentation/pages/register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController phoneController;
  late TextEditingController passwordController;

  String countryCode = '+233';

  @override
  void initState() {
    phoneController = new TextEditingController();
    passwordController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
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
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Welcome back! \nLet's go see some events.",
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.black,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextFieldTemplate(
                      hintText: "Phone",
                      controller: phoneController,
                      obscureText: false,
                      width: width,
                      height: 50,
                      textInputType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      enabled: true,
                    ),
                    textBoxSpace(),
                    TextFieldTemplate(
                      hintText: "Password",
                      controller: passwordController,
                      obscureText: false,
                      width: width,
                      height: 50,
                      textInputType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      enabled: true,
                    ),
                    textBoxSpace(),
                    SizedBox(
                      width: width,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ForgotPasswordScreen.routeName,
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontFamily: "Poppins",
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
                        Navigator.pushNamed(context, RegisterScreen.routeName);
                      },
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RegisterScreen.routeName,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        " Register",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.orange,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
