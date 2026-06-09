import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/utils/app_theme.dart';
import 'package:rapidlie/core/utils/date_formatters.dart';
import 'package:rapidlie/core/utils/get_invite_status.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/core/widgets/animations.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/core/widgets/event_card.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class InvitesScreen extends StatefulWidget {
  static const String routeName = "invites";
  const InvitesScreen({super.key});

  @override
  State<InvitesScreen> createState() => _InvitesScreenState();
}

class _InvitesScreenState extends State<InvitesScreen> {
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = UserPreferences().getUserId().toString();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InvitedEventBloc>().add(GetInvitedEvents());
    });
  }

  Future<void> _handleRefresh() async {
    context.read<InvitedEventBloc>().add(GetInvitedEvents());
    context.read<UpcomingEventBloc>().add(GetUpcomingEvents());
    context.read<PublicEventBloc>().add(GetPublicEvents());
    context.read<PrivateEventBloc>().add(GetPrivateEvents());
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: language.invites,
          isSubPage: false,
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _handleRefresh,
          child: BlocBuilder<InvitedEventBloc, EventListState>(
            builder: (context, state) {
              if (state is EventListInitial || state is InvitedEventLoading) {
                return _InvitesShimmer();
              }
              if (state is InvitedEventLoaded) {
                final events = state.events.reversed.toList();
                if (events.isEmpty) return _EmptyInvites();
                return _InvitesList(events: events, userId: userId);
              }
              return _EmptyInvites();
            },
          ),
        ),
      ),
    );
  }
}

// ── Shimmer skeleton ────────────────────────────────────────────────────────

class _InvitesShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      itemCount: 3,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              ShimmerBox(width: 38, height: 38, borderRadius: 19),
              const SizedBox(width: 10),
              ShimmerBox(width: 120, height: 13, borderRadius: 6),
            ]),
            const SizedBox(height: 10),
            ShimmerBox(
                width: w - 40, height: (w - 40) * 9 / 16, borderRadius: 14),
            const SizedBox(height: 10),
            ShimmerBox(width: w * 0.6, height: 14, borderRadius: 6),
            const SizedBox(height: 6),
            ShimmerBox(width: w * 0.38, height: 11, borderRadius: 6),
          ],
        ),
      ),
    );
  }
}

// ── Beautiful empty state ───────────────────────────────────────────────────

class _EmptyInvites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.08),
        Center(
          child: FadeSlideItem(
            index: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon container with gradient
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              const Color(0xFF1E1040),
                              const Color(0xFF2D1560),
                            ]
                          : [
                              AppColors.primaryLight,
                              AppColors.primary.withValues(alpha: 0.08),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: isDark ? 0.3 : 0.2),
                    ),
                  ),
                  child: const Icon(
                    Icons.mail_outline_rounded,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 28),

                Text(
                  'No invites yet',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    'When someone invites you to an event, it will appear here.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.55,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // Feature highlights
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      _FeatureRow(
                        icon: Icons.celebration_outlined,
                        color: AppColors.accentAmber,
                        title: 'Accept & RSVP',
                        subtitle: 'Confirm your attendance instantly',
                      ),
                      const SizedBox(height: 14),
                      _FeatureRow(
                        icon: Icons.group_add_outlined,
                        color: AppColors.accentEmerald,
                        title: 'Connect with hosts',
                        subtitle: 'View event details and guest lists',
                      ),
                      const SizedBox(height: 14),
                      _FeatureRow(
                        icon: Icons.qr_code_2_outlined,
                        color: AppColors.accentCyan,
                        title: 'Your tickets',
                        subtitle: 'Get QR codes for confirmed events',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _FeatureRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainerHighest
            : color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.2 : 0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface)),
                Text(subtitle,
                    style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: theme.colorScheme.outline)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Invites list ────────────────────────────────────────────────────────────

class _InvitesList extends StatelessWidget {
  final List<EventDataModel> events;
  final String userId;

  const _InvitesList({required this.events, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, bottom: 48),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: FadeSlideItem(
            index: index,
            staggerStep: const Duration(milliseconds: 50),
            child: PressScale(
              onTap: () {
                context.pushNamed(
                  'event_details',
                  extra: {
                    'eventId': event.id,
                    'isOwnEvent': event.user?.uuid == userId,
                  },
                );
              },
              child: EventCard(
                showOwnerInfo: true,
                eventOwner: event.username,
                eventOwnerAvatar: event.user?.avatar,
                eventName: event.name,
                eventLocation: event.venue.split(',').first,
                eventDay: getDayName(event.date),
                eventDate:
                    convertDateDotFormat(DateTime.parse(event.date)),
                eventImageString: event.image ?? '',
                eventId: event.id,
                hasLikedEvent: event.hasLikedEvent,
                inviteStatus: getInviteStatus(event, userId),
                showStatusBadge: true,
              ),
            ),
          ),
        );
      },
    );
  }
}
