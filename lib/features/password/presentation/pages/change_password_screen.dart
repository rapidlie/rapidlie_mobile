import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/core/widgets/textfield_template.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  static const String routeName = "change_password";

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController retypePasswordController;

  @override
  void initState() {
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    retypePasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                        ),
                      ),
                    ),
                    Text(
                      "It is okay to change \nthings up sometimes.",
                      style: mainAppbarTitleStyle(),
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextFieldTemplate(
                      hintText: "Old password",
                      controller: oldPasswordController,
                      obscureText: true,
                      width: width,
                      height: 50,
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      enabled: true,
                    ),
                    textBoxSpace(),
                    TextFieldTemplate(
                      hintText: "New password",
                      controller: newPasswordController,
                      obscureText: true,
                      width: width,
                      height: 50,
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      enabled: true,
                    ),
                    textBoxSpace(),
                    TextFieldTemplate(
                      hintText: "Retype password",
                      controller: retypePasswordController,
                      obscureText: true,
                      width: width,
                      height: 50,
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      enabled: true,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    ButtonTemplate(
                      buttonName: "Change password",
                      buttonWidth: width,
                      buttonAction: () {},
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
