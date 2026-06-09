import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_stack/image_stack.dart';
import 'package:latlong2/latlong.dart';
import 'package:rapidlie/core/utils/app_theme.dart';
import 'package:rapidlie/core/utils/date_formatters.dart';
import 'package:rapidlie/core/utils/get_invite_status.dart';
import 'package:rapidlie/core/utils/render_image.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/core/widgets/animations.dart';
import 'package:rapidlie/features/bookmarks/blocs/bookmark_bloc/bookmark_bloc.dart';
import 'package:rapidlie/features/events/blocs/event_detail_bloc/event_detail_bloc.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';
import 'package:rapidlie/features/events/blocs/give_consent_bloc/consent_bloc.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/features/events/presentation/pages/map_direction_launcher.dart';
import 'package:rapidlie/features/events/repository/event_detail_respository.dart';
import 'package:rapidlie/features/lens/blocs/lens_bloc/lens_bloc.dart';
import 'package:rapidlie/features/notifications/presentation/widgets/announce_sheet.dart';
import 'package:rapidlie/features/polls/blocs/poll_bloc/poll_bloc.dart';
import 'package:rapidlie/features/reels/presentation/screens/reels_screen.dart';
import 'package:rapidlie/features/sage/blocs/sage_bloc/sage_bloc.dart';
import 'package:rapidlie/features/tickets/blocs/ticket_bloc/ticket_bloc.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsScreen extends StatelessWidget {
  final bool isOwnEvent;
  final String eventId;

  const EventDetailsScreen({
    Key? key,
    required this.isOwnEvent,
    required this.eventId,
  }) : super(key: key);

  static EventDetailsScreen fromState(GoRouterState state) {
    final data = state.extra as Map<String, dynamic>;
    return EventDetailsScreen(
      eventId: data['eventId'] as String,
      isOwnEvent: data['isOwnEvent'] as bool,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventDetailBloc(
        eventdetailRepository: context.read<EventDetailRepository>(),
      )..add(GetEventDetail(eventId)),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocBuilder<EventDetailBloc, EventDetailState>(
          builder: (context, state) {
            if (state is EventDetailLoading) {
              return _LoadingSkeleton();
            } else if (state is EventDetailLoaded) {
              final event = state.events;
              final userId = UserPreferences().getUserId().toString();
              final inviteStatus = getInviteStatus(event, userId);
              return _EventDetailsBody(
                event: event,
                isOwnEvent: isOwnEvent,
                inviteStatus: inviteStatus,
              );
            } else if (state is EventDetailError) {
              return _ErrorState(message: state.message);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ── Loading skeleton ───────────────────────────────────────────────────────

class _LoadingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShimmerBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.42,
          borderRadius: 0,
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(width: 220, height: 22, borderRadius: 8),
              const SizedBox(height: 8),
              ShimmerBox(width: 100, height: 14, borderRadius: 6),
              const SizedBox(height: 24),
              ShimmerBox(width: double.infinity, height: 76, borderRadius: 14),
              const SizedBox(height: 20),
              ShimmerBox(width: 120, height: 16, borderRadius: 8),
              const SizedBox(height: 8),
              ShimmerBox(width: double.infinity, height: 60, borderRadius: 10),
              const SizedBox(height: 20),
              ShimmerBox(width: 120, height: 16, borderRadius: 8),
              const SizedBox(height: 8),
              ShimmerBox(width: double.infinity, height: 120, borderRadius: 10),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Error state ────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              ),
            ),
          ),
          const Spacer(),
          Icon(Icons.error_outline_rounded,
              size: 54, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          Text('Could not load event',
              style: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(message,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.outline),
              textAlign: TextAlign.center),
          const Spacer(),
        ],
      ),
    );
  }
}

// ── Main body ──────────────────────────────────────────────────────────────

class _EventDetailsBody extends StatelessWidget {
  final EventDataModel event;
  final bool isOwnEvent;
  final String? inviteStatus;

  const _EventDetailsBody({
    Key? key,
    required this.event,
    required this.isOwnEvent,
    required this.inviteStatus,
  }) : super(key: key);

  LatLng _latLng(String s) {
    final m = RegExp(r"LatLng\(([^,]+), ([^)]+)\)").firstMatch(s);
    if (m != null) {
      return LatLng(double.parse(m.group(1)!), double.parse(m.group(2)!));
    }
    return const LatLng(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final userImages = event.invitations
        .map((i) => i.user.avatar ?? 'assets/images/placeholder.png')
        .toList();
    final initialPosition = _latLng(event.mapLocation);

    // Bottom action bar height — keeps content clear of it
    const bottomBarH = 86.0;

    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            // ── Hero image ──────────────────────────────────────────────
            SliverAppBar(
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.height * 0.42,
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.headerStart,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.45),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 16),
                  ),
                ),
              ),
              actions: [
                // Bookmark
                BlocBuilder<BookmarkBloc, BookmarkState>(
                  builder: (context, bs) {
                    final isBookmarked = bs is BookmarkToggleSuccess &&
                        bs.isBookmarked;
                    return _HeaderAction(
                      icon: isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: isBookmarked
                          ? AppColors.accentAmber
                          : Colors.white,
                      onTap: () => context.read<BookmarkBloc>().add(
                            ToggleBookmark(
                                eventId: event.id,
                                bookmark: !isBookmarked),
                          ),
                    );
                  },
                ),
                // Calendar export
                _HeaderAction(
                  icon: Icons.calendar_month_rounded,
                  color: Colors.white,
                  onTap: () async {
                    final uri = Uri.parse(
                        '$flockrAPIBaseUrl/events/${event.id}/calendar.ics');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                ),
                if (isOwnEvent) ...[
                  _HeaderAction(
                    icon: Icons.auto_awesome_rounded,
                    color: Colors.white,
                    onTap: () {
                      context
                          .read<SageBloc>()
                          .add(FetchSageSuggestions(eventId: event.id));
                      context.pushNamed('sage', extra: event.id);
                    },
                  ),
                  _HeaderAction(
                    icon: Icons.insights_rounded,
                    color: Colors.white,
                    onTap: () {
                      context
                          .read<LensBloc>()
                          .add(FetchInsights(event.id));
                      context.pushNamed('insights', extra: event.id);
                    },
                  ),
                  _HeaderAction(
                    icon: Icons.campaign_rounded,
                    color: Colors.white,
                    onTap: () => AnnounceSheet.show(context, event.id),
                  ),
                ],
                const SizedBox(width: 4),
              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (event.image != null)
                      RenderImage(imageUrl: event.image!, fit: BoxFit.cover)
                    else
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.headerStart,
                              AppColors.headerEnd
                            ],
                          ),
                        ),
                        child: const Icon(Icons.event_rounded,
                            size: 80, color: Colors.white24),
                      ),
                    // Gradient scrim
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.08),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.65),
                            Colors.black.withValues(alpha: 0.88),
                          ],
                          stops: const [0.0, 0.35, 0.75, 1.0],
                        ),
                      ),
                    ),
                    // Overlaid title area
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Category pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              event.category.name.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            event.name,
                            style: GoogleFonts.inter(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.2,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.place_rounded,
                                  size: 13, color: Colors.white70),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  event.venue.split(',').first,
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: Colors.white70,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Content ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, bottomBarH + 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Date / Time / Type pill row ──────────────────────
                    FadeSlideItem(
                      index: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCard
                              : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          children: [
                            _InfoPill(
                              icon: Icons.calendar_today_rounded,
                              label: getDayName(event.date),
                              value: convertDateDotFormat(
                                  DateTime.parse(event.date)),
                              color: AppColors.primary,
                            ),
                            _Separator(),
                            _InfoPill(
                              icon: Icons.access_time_rounded,
                              label: language.time,
                              value: event.startTime,
                              color: AppColors.accentEmerald,
                            ),
                            _Separator(),
                            _InfoPill(
                              icon: event.eventType == 'public'
                                  ? Icons.public_rounded
                                  : Icons.lock_rounded,
                              label: 'Type',
                              value: event.eventType == 'public'
                                  ? 'Public'
                                  : 'Private',
                              color: event.eventType == 'public'
                                  ? AppColors.accentCyan
                                  : AppColors.accentAmber,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Description ───────────────────────────────────────
                    FadeSlideItem(
                      index: 1,
                      child: _Section(
                        label: language.description,
                        child: Text(
                          event.description,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            height: 1.65,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.75),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Directions ────────────────────────────────────────
                    FadeSlideItem(
                      index: 2,
                      child: _Section(
                        label: language.directions,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: MapDirectionLauncher(
                            targetLocation: initialPosition,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Moments (Reels) ───────────────────────────────────
                    FadeSlideItem(
                      index: 3,
                      child: _Section(
                        label: 'Moments',
                        trailing: _SeeAllButton(
                          label: 'View All',
                          onTap: () => context.pushNamed('reels', extra: {
                            'eventId': event.id,
                            'canPost': isOwnEvent ||
                                inviteStatus == 'accepted',
                          }),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 90,
                            child: ReelsScreen(
                              eventId: event.id,
                              canPost: false,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Polls ──────────────────────────────────────────────
                    FadeSlideItem(
                      index: 4,
                      child: PressScale(
                        onTap: () {
                          context
                              .read<PollBloc>()
                              .add(FetchPolls(event.id));
                          context.pushNamed('polls', extra: {
                            'eventId': event.id,
                            'isOrganizer': isOwnEvent,
                          });
                        },
                        child: _ActionTile(
                          icon: Icons.poll_rounded,
                          color: AppColors.accentAmber,
                          title: 'Polls',
                          subtitle: isOwnEvent
                              ? 'Create & manage polls'
                              : 'Vote on event polls',
                          isDark: isDark,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Invitations (private events) ───────────────────────
                    if (event.eventType == 'private') ...[
                      FadeSlideItem(
                        index: 5,
                        child: _Section(
                          label: language.invites,
                          trailing: isOwnEvent
                              ? _SeeAllButton(
                                  label: '+ Add',
                                  onTap: () => context.pushNamed(
                                    'flockr_contacts',
                                    extra: event.id,
                                  ),
                                )
                              : null,
                          child: const SizedBox.shrink(),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // ── Guest avatars ──────────────────────────────────────
                    if (userImages.isNotEmpty)
                      FadeSlideItem(
                        index: 6,
                        child: PressScale(
                          onTap: () => context.push(
                            '/guest_list',
                            extra: event.invitations,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkCard
                                  : theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: theme.colorScheme.outline
                                    .withValues(alpha: 0.15),
                              ),
                            ),
                            child: Row(
                              children: [
                                ImageStack(
                                  imageList: userImages,
                                  imageRadius: 40,
                                  showTotalCount: userImages.length > 4,
                                  imageBorderWidth: 2,
                                  imageCount:
                                      userImages.length > 4 ? 4 : userImages.length,
                                  imageBorderColor:
                                      isDark ? AppColors.darkCard : Colors.white,
                                  backgroundColor: AppColors.primary,
                                  extraCountBorderColor: AppColors.primary,
                                  totalCount: userImages.length,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${event.invitations.length} Guest${event.invitations.length == 1 ? '' : 's'}',
                                        style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                      Text(
                                        'Tap to view guest list',
                                        style: GoogleFonts.inter(
                                          fontSize: 11.sp,
                                          color: theme.colorScheme.outline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded,
                                    size: 13,
                                    color: theme.colorScheme.outline),
                              ],
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ── Bottom action bar ────────────────────────────────────────────
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _BottomBar(
            event: event,
            isOwnEvent: isOwnEvent,
            inviteStatus: inviteStatus,
          ),
        ),
      ],
    );
  }
}

// ── Bottom action bar ──────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final EventDataModel event;
  final bool isOwnEvent;
  final String? inviteStatus;

  const _BottomBar({
    required this.event,
    required this.isOwnEvent,
    required this.inviteStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.97)
            : theme.colorScheme.surface.withValues(alpha: 0.97),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.12),
          ),
        ),
      ),
      child: isOwnEvent
          ? _GradientButton(
              icon: Icons.qr_code_scanner_rounded,
              label: 'Scan Tickets',
              onTap: () =>
                  context.pushNamed('ticket_scanner', extra: event.id),
            )
          : inviteStatus == 'accepted'
              ? Row(
                  children: [
                    Expanded(
                      child: _GradientButton(
                        icon: Icons.confirmation_number_outlined,
                        label: 'My Ticket',
                        onTap: () {
                          context
                              .read<TicketBloc>()
                              .add(FetchEventTicket(event.id));
                          context.pushNamed('tickets');
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    _OutlineButton(
                      icon: Icons.volunteer_activism_rounded,
                      label: 'Contribute',
                      onTap: () => context.pushNamed('contribute', extra: {
                        'eventId': event.id,
                        'eventName': event.name,
                      }),
                    ),
                  ],
                )
              : event.eventType == 'public'
                  ? _GradientButton(
                      icon: Icons.volunteer_activism_rounded,
                      label: 'Contribute',
                      onTap: () =>
                          context.pushNamed('contribute', extra: {
                        'eventId': event.id,
                        'eventName': event.name,
                      }),
                    )
                  : _ConsentButtons(
                      event: event,
                      inviteStatus: inviteStatus,
                    ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _GradientButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [AppColors.primary, Color(0xFF9F5CF7)],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OutlineButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.55),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.primary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Consent buttons ────────────────────────────────────────────────────────

class _ConsentButtons extends StatelessWidget {
  final EventDataModel event;
  final String? inviteStatus;

  const _ConsentButtons({required this.event, required this.inviteStatus});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConsentBloc, ConsentState>(
      listener: (context, state) {
        if (state is ConsentLoadedState) {
          context.read<EventDetailBloc>().add(GetEventDetail(event.id));
          context.read<InvitedEventBloc>().add(GetInvitedEvents());
          context.read<UpcomingEventBloc>().add(GetUpcomingEvents());
          context.read<PublicEventBloc>().add(GetPublicEvents());
          context.read<PrivateEventBloc>().add(GetPrivateEvents());
          context.read<ConsentBloc>().add(ResetGiveConsentEvent());
        }
      },
      builder: (context, state) {
        final isLoading = state is ConsentLoadingState;
        String? status = inviteStatus;
        if (state is ConsentLoadedState) status = state.message;

        if (status == 'pending') {
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: _OutlineButton(
                  icon: Icons.close_rounded,
                  label: 'Decline',
                  onTap: isLoading
                      ? () {}
                      : () => context.read<ConsentBloc>().add(
                            GiveConsentEvent(
                                status: 'declined', eventId: event.id),
                          ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: isLoading
                    ? Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, Color(0xFF9F5CF7)],
                          ),
                        ),
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      )
                    : _GradientButton(
                        icon: Icons.check_rounded,
                        label: "Accept",
                        onTap: () => context.read<ConsentBloc>().add(
                              GiveConsentEvent(
                                  status: 'accepted', eventId: event.id),
                            ),
                      ),
              ),
            ],
          );
        }

        // Already responded
        final isDeclined = status == 'declined';
        return PressScale(
          onTap: isLoading
              ? null
              : () => context.read<ConsentBloc>().add(GiveConsentEvent(
                    status: isDeclined ? 'accepted' : 'declined',
                    eventId: event.id,
                  )),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: isDeclined
                  ? const Color(0xFFEF4444).withValues(alpha: 0.12)
                  : AppColors.accentEmerald.withValues(alpha: 0.12),
              border: Border.all(
                color: isDeclined
                    ? const Color(0xFFEF4444).withValues(alpha: 0.4)
                    : AppColors.accentEmerald.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isDeclined ? Icons.thumb_down_rounded : Icons.check_rounded,
                  color: isDeclined
                      ? const Color(0xFFEF4444)
                      : AppColors.accentEmerald,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  isDeclined ? 'Declined — tap to accept' : "You're going!",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDeclined
                        ? const Color(0xFFEF4444)
                        : AppColors.accentEmerald,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Reusable UI helpers ────────────────────────────────────────────────────

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _HeaderAction(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8, top: 10, bottom: 10),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.38),
          border:
              Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: Icon(icon, color: color, size: 17),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoPill(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 17),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              color: Theme.of(context).colorScheme.outline,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 48,
      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

class _Section extends StatelessWidget {
  final String label;
  final Widget child;
  final Widget? trailing;

  const _Section(
      {required this.label, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: -0.1,
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _SeeAllButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SeeAllButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color:
              AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool isDark;

  const _ActionTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
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
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    )),
                Text(subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: theme.colorScheme.outline,
                    )),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded,
              size: 13, color: theme.colorScheme.outline),
        ],
      ),
    );
  }
}
