import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/bottom_nav_screen.dart';
import 'package:rapidlie/core/widgets/animations.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
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
import 'package:rapidlie/features/settings/presentation/pages/app_settings_screen.dart';
import 'package:rapidlie/features/settings/presentation/pages/vault_enable_screen.dart';
import 'package:rapidlie/features/contributions/presentation/screens/my_contributions_screen.dart';
import 'package:rapidlie/features/events/presentation/pages/pending_invitations_screen.dart';
import 'package:rapidlie/features/contacts/presentation/pages/contact_list_screen.dart';
import 'package:rapidlie/splash_screen.dart';

CustomTransitionPage<void> _page(GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: pageTransitionBuilder,
      transitionDuration: const Duration(milliseconds: 280),
    );

final GoRouter appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    name: 'splash',
    pageBuilder: (context, state) => _page(state, const SplashScreen()),
  ),
  GoRoute(
    path: '/login',
    name: 'login',
    pageBuilder: (context, state) => _page(state, LoginScreen()),
  ),
  GoRoute(
    path: '/register',
    name: 'register',
    pageBuilder: (context, state) => _page(state, RegisterScreen()),
  ),
  GoRoute(
    path: '/otp',
    name: 'otp',
    pageBuilder: (context, state) => _page(state, OtpScreen()),
  ),
  GoRoute(
    path: '/forgot_password',
    name: 'forgot_password',
    pageBuilder: (context, state) => _page(state, ChangePasswordScreen()),
  ),
  GoRoute(
    path: '/request_password_reset',
    name: 'request_password_reset',
    pageBuilder: (context, state) =>
        _page(state, RequestResetPasswordScreen()),
  ),
  GoRoute(
    path: '/delete_account',
    name: 'delete_account',
    pageBuilder: (context, state) => _page(state, DeleteAccountScreen()),
  ),
  GoRoute(
    path: '/new_password',
    name: 'new_password',
    pageBuilder: (context, state) {
      final String email = state.extra as String;
      return _page(state, NewPasswordScreen(email: email));
    },
  ),
  GoRoute(
    path: '/bottom_nav',
    name: 'bottom_nav',
    pageBuilder: (context, state) {
      final int currentIndex = state.extra as int? ?? 0;
      return _page(state, BottomNavScreen(currentIndex: currentIndex));
    },
  ),
  GoRoute(
    path: '/category',
    name: 'category',
    pageBuilder: (context, state) {
      final extra = state.extra as Map<String, dynamic>;
      return _page(
        state,
        CategoryScreen(
          categoryId: extra['categoryId'] as String,
          categoryName: extra['categoryName'] as String,
        ),
      );
    },
  ),
  GoRoute(
    path: '/profile',
    name: 'profile',
    pageBuilder: (context, state) =>
        _page(state, ProfileSettingsScreen.fromState(state)),
  ),
  GoRoute(
    path: '/event_details',
    name: 'event_details',
    pageBuilder: (context, state) =>
        _page(state, EventDetailsScreen.fromState(state)),
  ),
  GoRoute(
    path: '/guest_list',
    name: 'guest_list',
    pageBuilder: (context, state) {
      final guests = state.extra as List<Invitation>?;
      return _page(state, GuestListScreen(guests: guests));
    },
  ),
  GoRoute(
    path: '/create_event',
    name: 'create_event',
    pageBuilder: (context, state) => _page(state, CreateEventScreen()),
  ),
  GoRoute(
    path: '/flockr_contacts',
    name: 'flockr_contacts',
    pageBuilder: (context, state) {
      final String id = state.extra as String;
      return _page(state, FlockrContactsScreen(id: id));
    },
  ),
  GoRoute(
    path: '/terms',
    name: 'terms',
    pageBuilder: (context, state) => _page(state, TermsAndConditionsScreen()),
  ),
  GoRoute(
    path: '/privacy',
    name: 'privacy',
    pageBuilder: (context, state) => _page(state, PrivacyPolicyScreen()),
  ),
  GoRoute(
    path: '/about',
    name: 'about',
    pageBuilder: (context, state) => _page(state, AboutScreen()),
  ),
  GoRoute(
    path: '/change_password',
    name: 'change_password',
    pageBuilder: (context, state) => _page(state, ChangePasswordScreen()),
  ),
  GoRoute(
    path: '/bookmarks',
    name: 'bookmarks',
    pageBuilder: (context, state) =>
        _page(state, const BookmarkedEventsScreen()),
  ),
  GoRoute(
    path: '/tickets',
    name: 'tickets',
    pageBuilder: (context, state) => _page(state, const MyTicketsScreen()),
  ),
  GoRoute(
    path: '/ticket_detail',
    name: 'ticket_detail',
    pageBuilder: (context, state) {
      final ticket = state.extra as TicketModel;
      return _page(state, TicketDetailScreen(ticket: ticket));
    },
  ),
  GoRoute(
    path: '/ticket_scanner',
    name: 'ticket_scanner',
    pageBuilder: (context, state) {
      final eventId = state.extra as String;
      return _page(state, TicketScannerScreen(eventId: eventId));
    },
  ),
  GoRoute(
    path: '/mood',
    name: 'mood',
    pageBuilder: (context, state) => _page(state, const MoodScreen()),
  ),
  GoRoute(
    path: '/mood_events',
    name: 'mood_events',
    pageBuilder: (context, state) => _page(state, const MoodEventsScreen()),
  ),
  GoRoute(
    path: '/sage',
    name: 'sage',
    pageBuilder: (context, state) {
      final eventId = state.extra as String;
      return _page(state, SageScreen(eventId: eventId));
    },
  ),
  GoRoute(
    path: '/insights',
    name: 'insights',
    pageBuilder: (context, state) {
      final eventId = state.extra as String;
      return _page(state, EventInsightsScreen(eventId: eventId));
    },
  ),
  GoRoute(
    path: '/contribute',
    name: 'contribute',
    pageBuilder: (context, state) {
      final extra = state.extra as Map<String, dynamic>;
      return _page(
        state,
        ContributeScreen(
          eventId: extra['eventId'] as String,
          eventName: extra['eventName'] as String,
        ),
      );
    },
  ),
  GoRoute(
    path: '/polls',
    name: 'polls',
    pageBuilder: (context, state) {
      final extra = state.extra as Map<String, dynamic>;
      return _page(
        state,
        PollsScreen(
          eventId: extra['eventId'] as String,
          isOrganizer: extra['isOrganizer'] as bool,
        ),
      );
    },
  ),
  GoRoute(
    path: '/reels',
    name: 'reels',
    pageBuilder: (context, state) {
      final extra = state.extra as Map<String, dynamic>;
      return _page(
        state,
        Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: AppBarTemplate(pageTitle: 'Moments', isSubPage: true),
          ),
          body: ReelsScreen(
            eventId: extra['eventId'] as String,
            canPost: extra['canPost'] as bool,
          ),
        ),
      );
    },
  ),
  GoRoute(
    path: '/groups',
    name: 'groups',
    pageBuilder: (context, state) => _page(state, const GroupsScreen()),
  ),
  GoRoute(
    path: '/group_detail',
    name: 'group_detail',
    pageBuilder: (context, state) {
      final groupId = state.extra as String;
      return _page(state, GroupDetailScreen(groupId: groupId));
    },
  ),
  GoRoute(
    path: '/create_group',
    name: 'create_group',
    pageBuilder: (context, state) => _page(state, const CreateGroupScreen()),
  ),
  GoRoute(
    path: '/app_settings',
    name: 'app_settings',
    pageBuilder: (context, state) => _page(state, const AppSettingsScreen()),
  ),
  GoRoute(
    path: '/vault_enable',
    name: 'vault_enable',
    pageBuilder: (context, state) => _page(state, const VaultEnableScreen()),
  ),
  GoRoute(
    path: '/my_contributions',
    name: 'my_contributions',
    pageBuilder: (context, state) =>
        _page(state, const MyContributionsScreen()),
  ),
  GoRoute(
    path: '/pending_invitations',
    name: 'pending_invitations',
    pageBuilder: (context, state) =>
        _page(state, const PendingInvitationsScreen()),
  ),
  GoRoute(
    path: '/contacts',
    name: 'contacts',
    pageBuilder: (context, state) => _page(state, const ContactListScreen()),
  ),
]);
