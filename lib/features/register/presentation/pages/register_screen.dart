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
import 'package:rapidlie/l10n/app_localizations.dart';

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
  var language;

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
    language = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
            child: BlocConsumer<RegisterBloc, RegisterState>(
              listener: (context, state) {
                if (state is RegisterSuccessState) {
                  AppSnackbars.showSuccess(context, language.success);
                  context.go('/otp');
                } else if (state is RegisterErrorState) {
                  AppSnackbars.showError(context, state.error);
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
                            language.registerMessage,
                            style: mainAppbarTitleStyle(context),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldTemplate(
                            hintText: language.fullName,
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
                            hintText: language.email,
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
                                      final dial = value.dialCode;
                                      if (dial == null || dial.isEmpty) return;
                                      setState(() => countryCode = dial);
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
                                    headerText: language.selectCountry,
                                    headerTextStyle: inter16Black600(context),
                                    pickerStyle: PickerStyle.bottomSheet,
                                    builder: (cc) {
                                      final dial = cc?.dialCode ?? countryCode;
                                      return Text(
                                        dial,
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
                                  hintText: language.phone,
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
                            hintText: language.password,
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
                            language.passwordLength,
                            style: inter10Black400(context),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          ButtonTemplate(
                            buttonName: language.register,
                            buttonType: ButtonType.elevated,
                            loading: state is RegisterLoadingState,
                            buttonAction: () {
                              if (emailController.text.isEmpty ||
                                  passwordController.text.isEmpty ||
                                  nameController.text.isEmpty) {
                                AppSnackbars.showError(
                                    context, language.requiredFields);
                                return;
                              }
                              BlocProvider.of<RegisterBloc>(context).add(
                                SubmitRegisterEvent(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text.isEmpty ? null :
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
                          context.push('/login');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              language.alreadyRegistered,
                              textAlign: TextAlign.right,
                              style: inter14black500(context),
                            ),
                            Text(
                              " " + language.login,
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
