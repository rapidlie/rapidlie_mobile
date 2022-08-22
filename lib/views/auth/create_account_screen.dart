import 'package:flutter/material.dart';
import 'package:rapidlie/components/button_template.dart';
import 'package:rapidlie/components/text_field_template.dart';
import 'package:rapidlie/constants/color_system.dart';
import 'package:rapidlie/views/rapid_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  static const String routeName = "createAccount";

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  late TextEditingController nameController, emailController;

  @override
  void initState() {
    nameController = new TextEditingController();
    emailController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFieldTemplate(
                  hintText: "Full name",
                  controller: nameController,
                  obscureText: false,
                  width: width,
                  height: 50,
                  textInputType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  enabled: true,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFieldTemplate(
                  hintText: "Email",
                  controller: emailController,
                  obscureText: false,
                  width: width,
                  height: 50,
                  textInputType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  enabled: true,
                ),
                SizedBox(
                  height: 30.0,
                ),
                ButtonTemplate(
                  buttonName: "Create account",
                  buttonColor: ColorSystem.primary,
                  buttonWidth: width,
                  buttonHeight: 50,
                  buttonAction: () {
                    Navigator.pushNamed(context, RapidScreen.routeName);
                  },
                  fontColor: ColorSystem.white,
                  textSize: 12.0,
                  buttonBorderRadius: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
