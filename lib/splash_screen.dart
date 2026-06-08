import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/features/categories/bloc/category_bloc.dart';
import 'package:rapidlie/features/contacts/blocs/contacts_bloc/contacts_bloc.dart';
import 'package:rapidlie/features/contacts/blocs/flockr_contacts_bloc/telephone_numbers_bloc.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';
import 'package:rapidlie/features/home/bloc/notifications_bloc.dart';
import 'package:rapidlie/features/settings/blocs/profile_bloc/profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = "splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalAuthentication _auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    context.read<CategoryBloc>().add(FetchCategoriesEvent());
    context.read<PublicEventBloc>().add(GetPublicEvents());
    context.read<UpcomingEventBloc>().add(GetUpcomingEvents());
    context.read<PrivateEventBloc>().add(GetPrivateEvents());
    context.read<ContactsBloc>().add(FetchContactsEvent());
    context.read<NotificationsBloc>().add(FetchNotificationsEvent());

    final isLoggedIn = await UserPreferences().getLoginStatus();
    final bearerToken = await UserPreferences().getBearerToken();

    if (!isLoggedIn || bearerToken.isEmpty) {
      if (!mounted) return;
      if (bearerToken.isEmpty && isLoggedIn) {
        context.go('/otp');
      } else {
        context.go('/login');
      }
      return;
    }

    // Check if biometric login is enabled
    final prefs = await SharedPreferences.getInstance();
    final biometricToken = prefs.getString('biometric_token');

    if (biometricToken != null && biometricToken.isNotEmpty) {
      await _tryBiometricAuth();
    } else {
      // No biometric — do the normal profile fetch to validate the session
      if (!mounted) return;
      context.read<ProfileBloc>().add(GetProfileEvent());
    }
  }

  Future<void> _tryBiometricAuth() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();

      if (!canCheck || !isDeviceSupported) {
        // Biometric unavailable — fall back to profile check
        if (!mounted) return;
        context.read<ProfileBloc>().add(GetProfileEvent());
        return;
      }

      final authenticated = await _auth.authenticate(
        localizedReason: 'Authenticate to access Flockr',
        biometricOnly: false,
      );

      if (!mounted) return;
      if (authenticated) {
        // Biometric passed — skip the profile API round-trip and go straight home
        context.read<ProfileBloc>().add(GetProfileEvent());
        BlocProvider.of<TelephoneNumbersBloc>(context).add(GetNumbers());
        context.go('/bottom_nav');
      } else {
        // User cancelled — offer login screen
        await UserPreferences().clearAll();
        context.go('/login');
      }
    } catch (_) {
      // Biometric error — fall back to normal profile check
      if (!mounted) return;
      context.read<ProfileBloc>().add(GetProfileEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoadingState) return;
          if (state is ProfileErrorState) {
            UserPreferences().clearAll();
            context.go('/login');
          } else if (state is ProfileLoadedState) {
            BlocProvider.of<TelephoneNumbersBloc>(context).add(GetNumbers());
            context.go('/bottom_nav');
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/flockrLG.png",
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
