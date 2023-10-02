import 'package:flutter/material.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/core/widgets/text_field_template.dart';
import 'package:rapidlie/views/auth/screens/create_account_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'signup';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController retypePasswordController;

  String countryCode = '+233';

  @override
  void initState() {
    phoneController = new TextEditingController();
    passwordController = new TextEditingController();
    retypePasswordController = new TextEditingController();
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
                    height: 10,
                  ),
                  TextFieldTemplate(
                    hintText: "Retype password",
                    controller: retypePasswordController,
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
                    buttonName: "Register",
                    buttonWidth: width,
                    buttonAction: () {
                      Navigator.pushNamed(
                        context,
                        CreateAccountScreen.routeName,
                      );
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
