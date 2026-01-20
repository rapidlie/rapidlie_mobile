import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rapidlie/core/router/app_router.dart';
import 'package:rapidlie/core/utils/app_theme.dart';
import 'package:rapidlie/core/utils/providers.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/settings/providers/change_language_provider.dart';
import 'package:rapidlie/injection_container.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences().init();
  setupLocator();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  final Locale deviceLocale = PlatformDispatcher.instance.locale;
  final String? countryCode = deviceLocale.countryCode;

  UserPreferences().setCountry(countryCode ?? "DE");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(393, 852),
      minTextAdapt: true,
      child: MultiProvider(
        providers: providers,
        child: Consumer<ChangeLanguageProvider>(
          builder: (context, language, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Flockr',
              locale: language.applicationLocale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              //theme: ThemeData(textTheme: GoogleFonts.interTextTheme()),
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system,
              routerConfig: appRouter,
            );
          },
        ),
      ),
    );
  }
}
