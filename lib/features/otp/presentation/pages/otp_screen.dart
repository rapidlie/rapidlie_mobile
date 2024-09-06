import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/otp/resend_bloc/resend_otp_bloc.dart';
import 'package:rapidlie/features/otp/verrify_bloc/verify_otp_bloc.dart';
import 'package:rapidlie/rapid_screen.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({Key? key}) : super(key: key);

  static const String routeName = 'otp';
  late String email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String email = " ";

  @override
  void initState() {
    getUserEmail();
    super.initState();
  }

  void getUserEmail() {
    email = UserPreferences().getUserEmail();
    UserPreferences().clearAll();
  }

  @override
  Widget build(BuildContext context) {
    print(email);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
            child: BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
              listener: (context, state) {
                if (state is VerifyOtpSuccessState) {
                  // Registration was successful
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successful')),
                  );

                  Navigator.pushReplacementNamed(
                    context,
                    RapidScreen.routeName,
                  );
                } else if (state is VerifyOtpErrorState) {
                  // Registration failed
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed: ${state.error}')),
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
                          Text("We just sent you a 4-digit\n code via SMS.",
                              style: mainAppbarTitleStyle()),
                        ],
                      ),
                      Center(
                        child: Column(
                          children: [
                            Pinput(
                              defaultPinTheme: defaultTheme,
                              focusedPinTheme: focusedTheme,
                              submittedPinTheme: focusedTheme,
                              onCompleted: (value) {
                                print(email);
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
                                  // Registration was successful
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Successful')),
                                  );
                                } else if (state is ResendOtpErrorState) {
                                  // Registration failed
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Failed: ${state.error}')),
                                  );
                                }
                              },
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap: () {
                                    print(email);
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
                                        "Didn't receive code?",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        " Resend",
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

  PinTheme defaultTheme = PinTheme(
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.black12,
      ),
    ),
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 14.0,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    ),
  );

  PinTheme focusedTheme = PinTheme(
    height: 55,
    width: 55,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.black,
      ),
    ),
  );
}
