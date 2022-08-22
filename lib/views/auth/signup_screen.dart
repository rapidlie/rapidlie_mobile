import 'package:flutter/material.dart';
import 'package:rapidlie/components/button_template.dart';
import 'package:rapidlie/components/intl_phone_field.dart';
import 'package:rapidlie/constants/color_system.dart';

import 'create_account_screen.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = 'signup';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
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
                    buttonName: "Register",
                    buttonColor: ColorSystem.primary,
                    buttonWidth: width,
                    buttonHeight: 50,
                    buttonAction: () {
                      Navigator.pushNamed(
                          context, CreateAccountScreen.routeName);
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
