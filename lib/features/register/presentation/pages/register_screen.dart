import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/app_snackbars.dart';
import 'package:rapidlie/core/utils/gravata_to_image.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/core/widgets/textfield_template.dart';
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
  bool obscureText = true;

  @override
  void initState() {
    phoneController = new TextEditingController();
    nameController = new TextEditingController();
    emailController = new TextEditingController();
    passwordController = new TextEditingController();
    alreadyRegistered();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> alreadyRegistered() async {
    if (await UserPreferences().getRegistrationStep() == "partial") {
      context.go('/otp');
    }
  }

  String removeLeadingZero(String phoneNumber) {
    if (phoneNumber.startsWith('0')) {
      return phoneNumber.substring(1);
    }
    return phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                  context.go('/otp');
                } else if (state is RegisterErrorState) {
                  AppSnackbars.showError(
                      context, 'Registration failed. Please try again.');
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
                            style: mainAppbarTitleStyle(context),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              Container(
                                height: 48,
                                width: 60.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Theme.of(context)
                                        .inputDecorationTheme
                                        .fillColor),
                                child: Center(
                                  child: CountryCodePicker(
                                    onChanged: (value) {
                                      setState(() {
                                        countryCode = value.dialCode!;
                                      });
                                    },
                                    initialSelection:
                                        UserPreferences().getCountry() ?? "DE",
                                    showCountryOnly: true,
                                    showOnlyCountryWhenClosed: true,
                                    alignLeft: false,
                                    showFlagDialog: true,
                                    showFlag: false,
                                    showDropDownButton: false,
                                    dialogBackgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    textStyle: inter14Black400(context),
                                    headerText: "Select a country",
                                    headerTextStyle: inter16Black600(context),
                                    pickerStyle: PickerStyle.bottomSheet,
                                    builder: (countryCode) {
                                      return Text(
                                        countryCode!.dialCode!,
                                        textAlign: TextAlign.center,
                                        style: inter13black400(context),
                                      );
                                    },
                                  ),
                                ),
                              ),
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
                                  textInputType: TextInputType.number,
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
                            obscureText: obscureText,
                            width: width,
                            height: 50,
                            textInputType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            enabled: true,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              child: Icon(
                                obscureText ? Icons.lock : Icons.lock_open,
                              ),
                            ),
                          ),
                          extraSmallHeight(),
                          Text(
                            "*Password must be at least 8 characters long.",
                            style: inter10Black400(context),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          ButtonTemplate(
                            buttonName: "Register",
                            buttonType: ButtonType.elevated,
                            loading: state is RegisterLoadingState,
                            buttonAction: () {
                              if (emailController.text.isEmpty ||
                                  passwordController.text.isEmpty ||
                                  nameController.text.isEmpty ||
                                  phoneController.text.isEmpty) {
                                AppSnackbars.showError(
                                    context, "All fields are required");
                                return;
                              }
                              BlocProvider.of<RegisterBloc>(context).add(
                                SubmitRegisterEvent(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone:
                                      removeLeadingZero(phoneController.text),
                                  countryCode: countryCode,
                                  profileImage: getGitHubIdenticonUrl(
                                    nameController.text
                                        .toString()
                                        .split(" ")
                                        .first,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go('/login');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Do you already have an account?",
                              textAlign: TextAlign.right,
                              style: inter14black500(context),
                            ),
                            Text(
                              " Login",
                              textAlign: TextAlign.right,
                              style: inter14Orange500(context),
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
