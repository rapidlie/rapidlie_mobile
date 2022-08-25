import 'package:flutter/material.dart';
import 'package:rapidlie/components/button_template.dart';
import 'package:rapidlie/components/country_code_picker.dart';
import 'package:rapidlie/components/intl_phone_field.dart';
import 'package:rapidlie/components/text_field_template.dart';
import 'package:rapidlie/constants/color_system.dart';

import 'create_account_screen.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = 'signup';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController controller;

  String countryCode = '+233';

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
                  ButtonTemplate(
                    buttonName: "Register",
                    buttonColor: ColorSystem.secondary,
                    buttonWidth: width,
                    buttonHeight: 50,
                    buttonAction: () {
                      Navigator.pushNamed(
                          context, CreateAccountScreen.routeName);
                    },
                    fontColor: ColorSystem.white,
                    textSize: 14,
                    buttonBorderRadius: 10.0,
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
