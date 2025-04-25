import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
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
      backgroundColor: CustomColors.white,
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Registration failed. Please check details and try again.")),
                  );
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
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: CustomColors.gray, width: 2),
                                ),
                                child: CountryListPick(
                                  appBar: AppBar(
                                    backgroundColor: CustomColors.white,
                                    title: Text(
                                      'Choose a country',
                                      style: poppins14black500(),
                                    ),
                                  ),
                                  pickerBuilder:
                                      (context, CountryCode? countryCode) {
                                    return Text(
                                      countryCode!.dialCode!,
                                      style: poppins14black500(),
                                    );
                                  },
                                  theme: CountryTheme(
                                    alphabetSelectedBackgroundColor:
                                        Colors.black,
                                    searchHintText:
                                        'Enter name of country here',
                                    isShowFlag: false,
                                    isShowTitle: false,
                                    isShowCode: true,
                                    isDownIcon: false,
                                    showEnglishName: false,
                                  ),
                                  initialSelection: countryCode,
                                  onChanged: (CountryCode? code) {
                                    setState(() {
                                      countryCode = code!.dialCode!;
                                    });
                                  },
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
                                color: CustomColors.black,
                              ),
                            ),
                          ),
                          extraSmallHeight(),
                          Text(
                            "*Password must be at least 8 characters long.",
                            style: inter10CharcoalBlack400(),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          ButtonTemplate(
                            buttonName: "Register",
                            buttonWidth: width,
                            loading: state is RegisterLoadingState,
                            buttonAction: () {
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
                              style: inter14black500(),
                            ),
                            Text(
                              " Login",
                              textAlign: TextAlign.right,
                              style: inter14Orange500(),
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
