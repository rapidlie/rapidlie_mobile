import 'package:flutter/material.dart';
import 'package:rapidlie/views/auth/create_account_screen.dart';
import 'package:rapidlie/views/auth/login_screen.dart';
import 'package:rapidlie/views/auth/signup_screen.dart';

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
