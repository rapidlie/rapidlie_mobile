import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/bottom_nav_screen.dart';
import 'package:rapidlie/features/categories/presentation/category_screen.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/features/events/presentation/pages/create_event/create_event_screen.dart';
import 'package:rapidlie/features/events/presentation/pages/event_details_screen.dart';
import 'package:rapidlie/features/events/presentation/pages/flockr_contacts_screen.dart';
import 'package:rapidlie/features/events/presentation/pages/guest_list_screen.dart';
import 'package:rapidlie/features/login/presentation/pages/login_screen.dart';
import 'package:rapidlie/features/otp/presentation/pages/otp_screen.dart';
import 'package:rapidlie/features/password/presentation/pages/change_password_screen.dart';
import 'package:rapidlie/features/password/presentation/pages/new_password_screen.dart';
import 'package:rapidlie/features/password/presentation/pages/request_reset_password_screen.dart';
import 'package:rapidlie/features/register/presentation/pages/register_screen.dart';
import 'package:rapidlie/features/settings/presentation/pages/delete_account_screen.dart';
import 'package:rapidlie/features/settings/presentation/pages/privacy_policy_screen.dart';
import 'package:rapidlie/features/settings/presentation/pages/profile_settings_screen.dart';
import 'package:rapidlie/features/settings/presentation/pages/terms_and_conditions_screen.dart';
import 'package:rapidlie/splash_screen.dart';

final GoRouter appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    name: 'splash',
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: '/login',
    name: 'login',
    builder: (context, state) => LoginScreen(),
  ),
  GoRoute(
    path: '/register',
    name: 'register',
    builder: (context, state) => RegisterScreen(),
  ),
  GoRoute(
    path: '/otp',
    name: 'otp',
    builder: (context, state) => OtpScreen(),
  ),
  GoRoute(
    path: '/forgot_password',
    name: 'forgot_password',
    builder: (context, state) => ChangePasswordScreen(),
  ),
  GoRoute(
    path: '/request_password_reset',
    name: 'request_password_reset',
    builder: (context, state) => RequestResetPasswordScreen(),
  ),
  GoRoute(
    path: '/delete_account',
    name: 'delete_account',
    builder: (context, state) => DeleteAccountScreen(),
  ),
  GoRoute(
    path: '/new_password:email',
    name: 'new_password',
    builder: (context, state) {
      final String email = state.pathParameters['email'] ?? '';
      return NewPasswordScreen(email: email);
    },
  ),
  GoRoute(
      path: '/bottom_nav',
      name: 'bottom_nav',
      builder: (context, state) {
        final int currentIndex = state.extra as int? ?? 0;
        return BottomNavScreen(currentIndex: currentIndex);
      }),
  GoRoute(
      path: '/category',
      name: 'category',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final String categoryId = extra['categoryId'] as String;
        final String categoryName = extra['categoryName'] as String;

        return MaterialPage(
          child: CategoryScreen(
            categoryId: categoryId,
            categoryName: categoryName,
          ),
        );
      }),
  GoRoute(
      path: '/profile',
      name: 'profile',
      pageBuilder: (context, state) {
        return MaterialPage(
          child: ProfileSettingsScreen.fromState(state),
        );
      }),
  GoRoute(
    path: '/event_details',
    name: 'event_details',
    pageBuilder: (context, state) => MaterialPage(
      child: EventDetailsScreen.fromState(state),
    ),
  ),
  GoRoute(
    path: '/guest_list',
    name: 'guest_list',
    pageBuilder: (context, state) {
      final guests = state.extra as List<Invitation>?;
      return MaterialPage(
        child: GuestListScreen(guests: guests),
      );
    },
  ),
  GoRoute(
    path: '/create_event',
    name: 'create_event',
    builder: (context, state) => CreateEventScreen(),
  ),
  GoRoute(
    path: '/flockr_contacts',
    name: 'flockr_contacts',
    builder: (context, state) {
      final String id = state.extra as String;
      return FlockrContactsScreen(id: id);
    },
  ),
  GoRoute(
    path: '/terms',
    name: 'terms',
    builder: (context, state) => TermsAndConditionsScreen(),
  ),
  GoRoute(
    path: '/privacy',
    name: 'privacy',
    builder: (context, state) => PrivacyPolicyScreen(),
  ),
]);
