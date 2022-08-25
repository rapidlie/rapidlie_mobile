import 'package:flutter/material.dart';
import 'package:rapidlie/views/auth/create_account_screen.dart';
import 'package:rapidlie/views/auth/login_screen.dart';
import 'package:rapidlie/views/auth/signup_screen.dart';
import 'package:rapidlie/views/events_screen.dart';
import 'package:rapidlie/views/home_screen.dart';
import 'package:rapidlie/views/invites_screen.dart';
import 'package:rapidlie/views/rapid_screen.dart';
import 'package:rapidlie/views/settings_screen.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rapidlie',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        LoginScreen.routeName: (context) => LoginScreen(),
        SignupScreen.routeName: (context) => SignupScreen(),
        CreateAccountScreen.routeName: (context) => CreateAccountScreen(),
        RapidScreen.routeName: (context) => RapidScreen(currentIndex: 0),
        HomeScreen.routeName: (context) => HomeScreen(),
        EventsScreen.routeName: (context) => EventsScreen(),
        InvitesScreen.routeName: (context) => InvitesScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
      },
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
