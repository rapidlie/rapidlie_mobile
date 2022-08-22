import 'package:flutter/material.dart';
import 'package:rapidlie/components/button_template.dart';
import 'package:rapidlie/components/intl_phone_field.dart';
import 'package:rapidlie/constants/color_system.dart';
import 'package:rapidlie/views/auth/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorSystem.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IntlPhoneField(
                    controller: controller,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  ButtonTemplate(
                    buttonName: "Login",
                    buttonColor: ColorSystem.primary,
                    buttonWidth: width,
                    buttonHeight: 50,
                    buttonAction: () {
                      Navigator.pushNamed(context, SignupScreen.routeName);
                    },
                    fontColor: ColorSystem.white,
                    textSize: 14,
                    buttonBorderRadius: 5.0,
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
