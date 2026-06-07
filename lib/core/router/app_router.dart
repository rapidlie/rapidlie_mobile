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
import 'package:rapidlie/features/settings/presentation/pages/about_screen.dart';
import 'package:rapidlie/features/settings/presentation/pages/delete_account_screen.dart';
import 'package:rapidlie/features/settings/presentation/pages/privacy_policy_screen.dart';
import 'package:rapidlie/features/settings/presentation/pages/profile_settings_screen.dart';
import 'package:rapidlie/features/settings/presentation/pages/terms_and_conditions_screen.dart';
import 'package:rapidlie/features/bookmarks/presentation/screens/bookmarked_events_screen.dart';
import 'package:rapidlie/features/tickets/data/models/ticket_model.dart';
import 'package:rapidlie/features/tickets/presentation/screens/my_tickets_screen.dart';
import 'package:rapidlie/features/tickets/presentation/screens/ticket_detail_screen.dart';
import 'package:rapidlie/features/tickets/presentation/screens/ticket_scanner_screen.dart';
import 'package:rapidlie/features/reels/presentation/screens/reels_screen.dart';
import 'package:rapidlie/features/polls/presentation/screens/polls_screen.dart';
import 'package:rapidlie/features/contributions/presentation/screens/contribute_screen.dart';
import 'package:rapidlie/features/lens/presentation/screens/event_insights_screen.dart';
import 'package:rapidlie/features/sage/presentation/screens/sage_screen.dart';
import 'package:rapidlie/features/mood/presentation/screens/mood_screen.dart';
import 'package:rapidlie/features/mood/presentation/screens/mood_events_screen.dart';
import 'package:rapidlie/features/groups/presentation/screens/groups_screen.dart';
import 'package:rapidlie/features/groups/presentation/screens/group_detail_screen.dart';
import 'package:rapidlie/features/groups/presentation/screens/create_group_screen.dart';
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
    path: '/new_password',
    name: 'new_password',
    builder: (context, state) {
      final String email = state.extra as String;
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
  GoRoute(
    path: '/about',
    name: 'about',
    builder: (context, state) => AboutScreen(),
  ),
  GoRoute(
    path: '/change_password',
    name: 'change_password',
    builder: (context, state) => ChangePasswordScreen(),
  ),
  GoRoute(
    path: '/bookmarks',
    name: 'bookmarks',
    builder: (context, state) => const BookmarkedEventsScreen(),
  ),
  GoRoute(
    path: '/tickets',
    name: 'tickets',
    builder: (context, state) => const MyTicketsScreen(),
  ),
  GoRoute(
    path: '/ticket_detail',
    name: 'ticket_detail',
    builder: (context, state) {
      final ticket = state.extra as TicketModel;
      return TicketDetailScreen(ticket: ticket);
    },
  ),
  GoRoute(
    path: '/ticket_scanner',
    name: 'ticket_scanner',
    builder: (context, state) {
      final eventId = state.extra as String;
      return TicketScannerScreen(eventId: eventId);
    },
  ),
  GoRoute(
    path: '/mood',
    name: 'mood',
    builder: (context, state) => const MoodScreen(),
  ),
  GoRoute(
    path: '/mood_events',
    name: 'mood_events',
    builder: (context, state) => const MoodEventsScreen(),
  ),
  GoRoute(
    path: '/sage',
    name: 'sage',
    builder: (context, state) {
      final eventId = state.extra as String;
      return SageScreen(eventId: eventId);
    },
  ),
  GoRoute(
    path: '/insights',
    name: 'insights',
    builder: (context, state) {
      final eventId = state.extra as String;
      return EventInsightsScreen(eventId: eventId);
    },
  ),
  GoRoute(
    path: '/contribute',
    name: 'contribute',
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>;
      return ContributeScreen(
        eventId: extra['eventId'] as String,
        eventName: extra['eventName'] as String,
      );
    },
  ),
  GoRoute(
    path: '/polls',
    name: 'polls',
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>;
      return PollsScreen(
        eventId: extra['eventId'] as String,
        isOrganizer: extra['isOrganizer'] as bool,
      );
    },
  ),
  GoRoute(
    path: '/reels',
    name: 'reels',
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>;
      return Scaffold(
        appBar: AppBar(title: const Text('Moments')),
        body: ReelsScreen(
          eventId: extra['eventId'] as String,
          canPost: extra['canPost'] as bool,
        ),
      );
    },
  ),
  GoRoute(
    path: '/groups',
    name: 'groups',
    builder: (context, state) => const GroupsScreen(),
  ),
  GoRoute(
    path: '/group_detail',
    name: 'group_detail',
    builder: (context, state) {
      final groupId = state.extra as String;
      return GroupDetailScreen(groupId: groupId);
    },
  ),
  GoRoute(
    path: '/create_group',
    name: 'create_group',
    builder: (context, state) => const CreateGroupScreen(),
  ),
]);
