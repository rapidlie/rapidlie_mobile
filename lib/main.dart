import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapidlie/features/password/presentation/pages/change_password_screen.dart';
import 'package:rapidlie/features/login/presentation/pages/login_screen.dart';
import 'package:rapidlie/features/otp/presentation/pages/otp_screen.dart';
import 'package:rapidlie/features/event/presentation/pages/events_screen.dart';
import 'package:rapidlie/features/home/presentation/pages/home_screen.dart';
import 'package:rapidlie/features/invite/presentation/pages/invites_screen.dart';
import 'package:rapidlie/rapid_screen.dart';
import 'package:rapidlie/features/settings/presentation/pages/settings_screen.dart';

import 'features/register/presentation/pages/register_screen.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rapidlie',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        RapidScreen.routeName: (context) => RapidScreen(currentIndex: 0),
        HomeScreen.routeName: (context) => HomeScreen(),
        EventsScreen.routeName: (context) => EventsScreen(),
        InvitesScreen.routeName: (context) => InvitesScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
        OtpScreen.routeName: (context) => OtpScreen(),
        ChangePasswordScreen.routeName: (context) => ChangePasswordScreen(),
      },
      //initialRoute: RapidScreen.routeName,
      initialRoute: LoginScreen.routeName,
      onGenerateRoute: (RouteSettings settings) {
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return null;
      },
    );
  }
}
