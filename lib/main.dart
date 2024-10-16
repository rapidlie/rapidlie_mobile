import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/categories/bloc/category_bloc.dart';
import 'package:rapidlie/features/categories/presentation/category_screen.dart';
import 'package:rapidlie/features/categories/repository/category_repository.dart';
import 'package:rapidlie/features/contacts/bloc/telephone_numbers_bloc.dart';
import 'package:rapidlie/features/contacts/presentation/pages/contact_list_screen.dart';
import 'package:rapidlie/features/contacts/repository/telephone_numbers_repository.dart';
import 'package:rapidlie/features/events/bloc/create_event_bloc.dart';
import 'package:rapidlie/features/events/bloc/event_bloc.dart';
import 'package:rapidlie/features/events/provider/create_event_provider.dart';
import 'package:rapidlie/features/events/repository/create_event_repository.dart';
import 'package:rapidlie/features/events/repository/event_respository.dart';
import 'package:rapidlie/features/file_upload/bloc/file_upload_bloc.dart';
import 'package:rapidlie/features/file_upload/repository/file_upload_repository.dart';
import 'package:rapidlie/features/login/bloc/login_bloc.dart';
import 'package:rapidlie/features/login/repository/login_repository.dart';
import 'package:rapidlie/features/otp/repository/resend_otp_repository.dart';
import 'package:rapidlie/features/otp/resend_bloc/resend_otp_bloc.dart';
import 'package:rapidlie/features/otp/verrify_bloc/verify_otp_bloc.dart';
import 'package:rapidlie/features/otp/repository/verify_otp_repositoy.dart';
import 'package:rapidlie/features/password/presentation/pages/change_password_screen.dart';
import 'package:rapidlie/features/login/presentation/pages/login_screen.dart';
import 'package:rapidlie/features/otp/presentation/pages/otp_screen.dart';
import 'package:rapidlie/features/events/presentation/pages/events_screen.dart';
import 'package:rapidlie/features/home/presentation/pages/home_screen.dart';
import 'package:rapidlie/features/invites/presentation/pages/invites_screen.dart';
import 'package:rapidlie/features/register/bloc/register_bloc.dart';
import 'package:rapidlie/features/register/repository/register_repository.dart';
import 'package:rapidlie/features/settings/providers/change_language_provider.dart';
import 'package:rapidlie/injection_container.dart';
import 'package:rapidlie/l10n/app_localizations.dart';
import 'package:rapidlie/rapid_screen.dart';
import 'package:rapidlie/features/settings/presentation/pages/settings_screen.dart';
import 'package:rapidlie/splash_screen.dart';
import 'features/register/presentation/pages/register_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences().init();
  setupLocator();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
            BlocProvider<PrivateEventBloc>(
              create: (context) {
                final eventRepository = locator<EventRepository>();
                return PrivateEventBloc(eventRepository: eventRepository);
              },
            ),
            BlocProvider<PublicEventBloc>(
              create: (context) {
                final eventRepository = locator<EventRepository>();
                return PublicEventBloc(eventRepository: eventRepository);
              },
            ),
            BlocProvider<UpcomingEventBloc>(
              create: (context) {
                final eventRepository = locator<EventRepository>();
                return UpcomingEventBloc(eventRepository: eventRepository);
              },
            ),
            BlocProvider<EventByCategoryBloc>(
              create: (context) {
                final eventRepository = locator<EventRepository>();
                return EventByCategoryBloc(eventRepository: eventRepository);
              },
            ),
            BlocProvider<VerifyOtpBloc>(
              create: (context) => VerifyOtpBloc(
                verifyOtpRepository: VerifyOtpRepository(dio: Dio()),
              ),
            ),
            BlocProvider(
              create: (context) => RegisterBloc(
                registerRepository: RegisterRepository(dio: Dio()),
              ),
            ),
            BlocProvider(
              create: (context) => LoginBloc(
                loginRepository: LoginRepository(dio: Dio()),
              ),
            ),
            BlocProvider(
              create: (context) => ResendOtpBloc(
                resendOtpRepository: ResendOtpRepository(dio: Dio()),
              ),
            ),
            BlocProvider(
              create: (context) => CategoryBloc(
                categoryRepository: CategoryRepository(dio: Dio()),
              ),
            ),
            BlocProvider(
              create: (context) {
                final telephoneNumbersRepository =
                    locator<TelephoneNumbersRepository>();
                return TelephoneNumbersBloc(
                    telephoneNumbersRepository: telephoneNumbersRepository);
              },
            ),
            BlocProvider(
              create: (context) => FileUploadBloc(
                fileUploadRepository: FileUploadRepository(dio: Dio()),
              ),
            ),
            BlocProvider(
              create: (context) =>
                  CreateEventBloc(CreateEventRepository(dio: Dio())),
            ),
            ChangeNotifierProvider(
              create: (context) => ChangeLanguageProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => CreateEventProvider(),
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
                  SplashScreen.routeName: (context) => SplashScreen(),
                  CategoryScreen.routeName: (context) => CategoryScreen(),
                  ContactListScreen.routeName: (context) => ContactListScreen(),
                },
                initialRoute: SplashScreen.routeName,
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
