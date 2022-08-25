import 'package:flutter/material.dart';
import 'package:rapidlie/components/button_template.dart';
import 'package:rapidlie/components/country_code_picker.dart';
import 'package:rapidlie/components/intl_phone_field.dart';
import 'package:rapidlie/components/text_field_template.dart';
import 'package:rapidlie/constants/color_system.dart';
import 'package:rapidlie/views/auth/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController controller;

  String countryCode = '+233';

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
                  /* IntlPhoneField(
                    controller: controller,
                  ), */
                  Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      Expanded(
                        flex: 20,
                        child: TextFieldTemplate(
                          hintText: "Phone",
                          controller: controller,
                          obscureText: false,
                          width: width,
                          height: 50,
                          textInputType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          enabled: true,
                          leftContentPadding: 120,
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: CountryCodeLayout(
                            countryCode: countryCode,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ButtonTemplate(
                      buttonName: "Login",
                      buttonColor: ColorSystem.secondary,
                      buttonWidth: width,
                      buttonHeight: 50,
                      buttonAction: () {
                        Navigator.pushNamed(context, SignupScreen.routeName);
                      },
                      fontColor: ColorSystem.white,
                      textSize: 14,
                      buttonBorderRadius: 10.0,
                    ),
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
