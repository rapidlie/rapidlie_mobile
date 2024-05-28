import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rapidlie/features/password/presentation/pages/change_password_screen.dart';
import 'package:rapidlie/features/login/presentation/pages/login_screen.dart';
import 'package:rapidlie/features/otp/presentation/pages/otp_screen.dart';
import 'package:rapidlie/features/event/presentation/pages/events_screen.dart';
import 'package:rapidlie/features/home/presentation/pages/home_screen.dart';
import 'package:rapidlie/features/invite/presentation/pages/invites_screen.dart';
import 'package:rapidlie/features/settings/presentation/providers/change_language_provider.dart';
import 'package:rapidlie/l10n/app_localizations.dart';
import 'package:rapidlie/rapid_screen.dart';
import 'package:rapidlie/features/settings/presentation/pages/settings_screen.dart';

import 'features/register/presentation/pages/register_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(393, 852),
      minTextAdapt: true,
      child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => ChangeLanguageProvider(),
            ),
          ],
          child: Consumer<ChangeLanguageProvider>(
            builder: (context, language, child) {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Rapidlie',
                locale: language.applicationLocale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: ThemeData(
                  textTheme: TextTheme(
                    bodyLarge: TextStyle(color: Colors.black),
                  ),
                  //primarySwatch: Colors.blue,
                  primaryColor: Colors.black,

                  fontFamily: "Poppins",
                ),
                routes: <String, WidgetBuilder>{
                  LoginScreen.routeName: (context) => LoginScreen(),
                  RegisterScreen.routeName: (context) => RegisterScreen(),
                  RapidScreen.routeName: (context) =>
                      RapidScreen(currentIndex: 0),
                  HomeScreen.routeName: (context) => HomeScreen(),
                  EventsScreen.routeName: (context) => EventsScreen(),
                  InvitesScreen.routeName: (context) => InvitesScreen(),
                  SettingsScreen.routeName: (context) => SettingsScreen(),
                  OtpScreen.routeName: (context) => OtpScreen(),
                  ChangePasswordScreen.routeName: (context) =>
                      ChangePasswordScreen(),
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
            },
          )),
    );
  }
}
