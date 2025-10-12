import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/app_snackbars.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/otp/resend_bloc/resend_otp_bloc.dart';
import 'package:rapidlie/features/otp/verify_bloc/verify_otp_bloc.dart';
import 'package:rapidlie/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String email = " ";
  var language;

  @override
  void initState() {
    getUserEmail();
    super.initState();
  }

  void getUserEmail() async {
    email = await UserPreferences().getUserEmail();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    language = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
            child: BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
              listener: (context, state) {
                if (state is VerifyOtpSuccessState) {
                  AppSnackbars.showSuccess(context, language.success);
                  context.go('/bottom_nav');
                } else if (state is VerifyOtpErrorState) {
                  AppSnackbars.showError(context, language.failed);
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            child: GestureDetector(
                              onTap: () {
                                context.go('/register');
                              },
                              child: Icon(
                                Icons.arrow_back,
                              ),
                            ),
                          ),
                          Text(
                            language.resendMessage,
                            style: mainAppbarTitleStyle(context),
                          ),
                        ],
                      ),
                      Center(
                        child: Column(
                          children: [
                            Pinput(
                              defaultPinTheme: getDefaultTheme(context),
                              focusedPinTheme: getFocusedTheme(),
                              submittedPinTheme: getFocusedTheme(),
                              onCompleted: (value) {
                                BlocProvider.of<VerifyOtpBloc>(context).add(
                                  SubmitVerifyOtpEvent(
                                    email: email,
                                    otp: value,
                                  ),
                                );
                              },
                              autofocus: true,
                            ),
                            SizedBox(
                              height: 48,
                            ),
                            BlocConsumer<ResendOtpBloc, ResendOtpState>(
                              listener: (context, state) {
                                if (state is ResendOtpSuccessState) {
                                  AppSnackbars.showSuccess(
                                      context, language.success);
                                } else if (state is ResendOtpErrorState) {
                                  AppSnackbars.showError(
                                      context, language.failed);
                                }
                              },
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<ResendOtpBloc>(context).add(
                                      SubmitResendOtpEvent(
                                        email: email,
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        language.noCode,
                                        textAlign: TextAlign.right,
                                        style: inter14black500(context),
                                      ),
                                      Text(
                                        " " + language.resend,
                                        textAlign: TextAlign.right,
                                        style: inter14Orange500(context),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }

  PinTheme getDefaultTheme(BuildContext context) {
    return PinTheme(
      height: 50.h,
      width: 50.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
        ),
      ),
      textStyle: inter14black500(context),
    );
  }

  PinTheme getFocusedTheme() {
    return PinTheme(
      height: 55.h,
      width: 55.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
