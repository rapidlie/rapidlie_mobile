import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/categories/bloc/category_bloc.dart';
import 'package:rapidlie/features/contacts/blocs/contacts_bloc/contacts_bloc.dart';
import 'package:rapidlie/features/contacts/blocs/flockr_contacts_bloc/telephone_numbers_bloc.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';
import 'package:rapidlie/features/login/presentation/pages/login_screen.dart';
import 'package:rapidlie/features/otp/presentation/pages/otp_screen.dart';
import 'package:rapidlie/features/settings/blocs/profile_bloc/profile_bloc.dart';
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
    context.read<ProfileBloc>().add(GetProfileEvent());
    context.read<CategoryBloc>().add(FetchCategoriesEvent());
    context.read<PublicEventBloc>().add(GetPublicEvents());
    context.read<UpcomingEventBloc>().add(GetUpcomingEvents());
    context.read<PrivateEventBloc>().add(GetPrivateEvents());
    context.read<ContactsBloc>().add(FetchContactsEvent());
    super.initState();
  }

  checkLoginStatus() async {
    bool isLoggedIn = await UserPreferences().getLoginStatus();
    String bearerToken = await UserPreferences().getBearerToken();

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
      body: BlocConsumer<ContactsBloc, ContactsState>(
        listener: (context, state) {
          if (state is ContactError) {
            print("Error");
          } else if (state is ContactLoaded) {
            print("Loaded");
          }
        },
        builder: (context, state) {
          return BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is ProfileLoadingState) {
                } else if (state is ProfileErrorState) {
                  UserPreferences().clearAll();
                  checkLoginStatus();
                } else if (state is ProfileLoadedState) {
                  BlocProvider.of<TelephoneNumbersBloc>(context)
                      .add(GetNumbers());
                  Navigator.pushReplacementNamed(
                      context, RapidScreen.routeName);
                }
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/flockrLG.png"),
                      SizedBox(
                        height: 20,
                      ),
                      LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      )
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}


/* 

return Scaffold(
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoadingState) {
          } else if (state is ProfileErrorState) {
            UserPreferences().clearAll();

            checkLoginStatus();
          } else if (state is ProfileLoadedState) {
            Navigator.pushReplacementNamed(context, RapidScreen.routeName);
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/flockrLG.png"),
                SizedBox(
                  height: 20,
                ),
                LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  borderRadius: BorderRadius.circular(8),
                )
              ],
            ),
          ),
        ),
      ),
    );

 */
