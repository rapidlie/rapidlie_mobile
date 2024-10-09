import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/core/constants/color_constants.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/core/widgets/country_code_picker.dart';
import 'package:rapidlie/core/widgets/textfield_template.dart';
import 'package:rapidlie/features/login/presentation/pages/login_screen.dart';
import 'package:rapidlie/features/otp/presentation/pages/otp_screen.dart';
import 'package:rapidlie/features/register/bloc/register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'signup';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController phoneController;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  String countryCode = '+49';

  @override
  void initState() {
    phoneController = new TextEditingController();
    nameController = new TextEditingController();
    emailController = new TextEditingController();
    passwordController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String removeLeadingZero(String phoneNumber) {
    if (phoneNumber.startsWith('0')) {
      return phoneNumber.substring(1);
    }
    return phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
            child: BlocConsumer<RegisterBloc, RegisterState>(
              listener: (context, state) {
                if (state is RegisterSuccessState) {
                  // Registration was successful
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registration Successful')),
                  );

                  // Navigate to another screen or perform other actions
                  Navigator.pushReplacementNamed(
                    context,
                    OtpScreen.routeName,
                    arguments: emailController.text,
                  );
                  // Example: Navigate to home
                } else if (state is RegisterErrorState) {
                  print("failed");
                }
              },
              builder: (context, state) {
                return Container(
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
                            "Register to get started.",
                            style: mainAppbarTitleStyle(),
                          ),
                        ],
                      ),
                      Column(
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
                          extraSmallHeight(),
                          TextFieldTemplate(
                            hintText: "Email",
                            controller: emailController,
                            obscureText: false,
                            width: width,
                            height: 50,
                            textInputType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            enabled: true,
                          ),
                          extraSmallHeight(),
                          Row(
                            children: [
                              CountryCodeLayout(countryCode: countryCode),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: TextFieldTemplate(
                                  hintText: "Phone",
                                  controller: phoneController,
                                  obscureText: false,
                                  width: width,
                                  height: 50,
                                  textInputType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  enabled: true,
                                ),
                              ),
                            ],
                          ),
                          extraSmallHeight(),
                          TextFieldTemplate(
                            hintText: "Password",
                            controller: passwordController,
                            obscureText: true,
                            width: width,
                            height: 50,
                            textInputType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            enabled: true,
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          ButtonTemplate(
                            buttonName: "Register",
                            buttonWidth: width,
                            buttonAction: () {
                              print(
                                nameController.text +
                                    emailController.text +
                                    passwordController.text +
                                    phoneController.text +
                                    countryCode,
                              );
                              BlocProvider.of<RegisterBloc>(context).add(
                                SubmitRegisterEvent(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone:
                                        removeLeadingZero(phoneController.text),
                                    countryCode: countryCode),
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
                              "Do you already have an account?",
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
                                color: Colors.deepOrange,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }
}
