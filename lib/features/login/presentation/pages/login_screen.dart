import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/color_constants.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/core/widgets/text_field_template.dart';

import '../../../../views/auth/screens/signup_screen.dart';

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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  SizedBox(
                    height: 10,
                  ),
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
                  SizedBox(
                    height: 30.0,
                  ),
                  ButtonTemplate(
                    buttonName: "Login",
                    buttonWidth: width,
                    buttonAction: () {
                      Navigator.pushNamed(context, SignupScreen.routeName);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
