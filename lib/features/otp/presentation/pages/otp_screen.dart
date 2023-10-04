import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  static const String routeName = 'otp';

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  List<TextEditingController> controllers =
      List.generate(4, (index) => TextEditingController());

  void otpFieldListener(int index) {
    if (index < 3) {
      focusNodes[index].unfocus();
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    }
  }

  void _handleKeyPress(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      // Handle backspace key press to delete the current or previous digit
      if (index > 0) {
        // If not the first digit, delete the current digit and move focus back
        controllers[index - 1].text = '';
        FocusScope.of(context).requestFocus(focusNodes[index - 1]);
      } else {
        // If it's the first digit, just clear it
        controllers[index].text = '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      "We just sent you \na 4-digit code via SMS.",
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.black,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Column(
                    children: [
                      Pinput(
                        defaultPinTheme: defaultTheme,
                        focusedPinTheme: focusedTheme,
                        autofocus: true,
                      ),
                      SizedBox(
                        height: 48,
                      ),
                      GestureDetector(
                        onTap: () {},
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
                                color: Colors.orange,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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

  PinTheme defaultTheme = PinTheme(
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        color: Colors.black,
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
    height: 60,
    width: 60,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        color: Colors.black,
      ),
    ),
  );
}
