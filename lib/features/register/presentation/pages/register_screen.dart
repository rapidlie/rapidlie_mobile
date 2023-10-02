import 'package:flutter/material.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/core/widgets/text_field_template.dart';
import 'package:rapidlie/features/login/presentation/pages/login_screen.dart';
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
                      "Hello! Register to get \nstarted.",
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
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      LoginScreen.routeName,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        " Login",
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
