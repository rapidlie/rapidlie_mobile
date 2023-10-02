import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapidlie/features/forgot_password/presentation/pages/forgot_password_screen.dart';
import 'package:rapidlie/views/auth/screens/create_account_screen.dart';
import 'package:rapidlie/features/login/presentation/pages/login_screen.dart';
import 'package:rapidlie/views/events/screens/events_screen.dart';
import 'package:rapidlie/views/home/screens/home_screen.dart';
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
        CreateAccountScreen.routeName: (context) => CreateAccountScreen(),
        RapidScreen.routeName: (context) => RapidScreen(currentIndex: 0),
        HomeScreen.routeName: (context) => HomeScreen(),
        EventsScreen.routeName: (context) => EventsScreen(),
        InvitesScreen.routeName: (context) => InvitesScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
        ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
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
