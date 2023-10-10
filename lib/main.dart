import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapidlie/features/change_password/presentation/pages/change_password_screen.dart';
import 'package:rapidlie/features/login/presentation/pages/login_screen.dart';
import 'package:rapidlie/features/otp/presentation/pages/otp_screen.dart';
import 'package:rapidlie/views/events/screens/events_screen.dart';
import 'package:rapidlie/features/event/presentation/pages/home_screen.dart';
import 'package:rapidlie/views/invites/screens/invites_screen.dart';
import 'package:rapidlie/views/rapid_screen.dart';
import 'package:rapidlie/views/settings_screen.dart';

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
