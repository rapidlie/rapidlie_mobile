import 'package:flutter/material.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/login/presentation/pages/login_screen.dart';
import 'package:rapidlie/features/otp/presentation/pages/otp_screen.dart';
import 'package:rapidlie/rapid_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = "splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkLoginStatus();
    super.initState();
  }

  checkLoginStatus() async {
    bool isLoggedIn = await UserPreferences().getLoginStatus();
    String? bearerToken = await UserPreferences().getBearerToken();

    if (isLoggedIn && bearerToken == "") {
      Navigator.pushReplacementNamed(context, OtpScreen.routeName);
    } else if (isLoggedIn && bearerToken != "") {
      Navigator.pushReplacementNamed(context, RapidScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100.0),
          child: Image.asset("assets/images/flockrLG.png"),
        ),
      ),
    );
  }
}
