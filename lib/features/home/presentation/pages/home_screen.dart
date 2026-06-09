import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/utils/date_formatters.dart';
import 'package:rapidlie/core/utils/get_invite_status.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/core/utils/time_of_day.dart';
import 'package:rapidlie/core/widgets/animations.dart';
import 'package:rapidlie/core/widgets/event_card.dart';
import 'package:rapidlie/features/categories/bloc/category_bloc.dart';
import 'package:rapidlie/features/categories/models/category_model.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/features/home/bloc/notifications_bloc.dart';
import 'package:rapidlie/features/home/models/notification.dart';
import 'package:rapidlie/features/home/presentation/widgets/upcoming_event_list_template.dart';
import 'package:rapidlie/core/utils/app_theme.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String _name = '';
  String _userId = '';
  List<EventDataModel> _publicEvents = [];
  List<EventDataModel> _upcomingEvents = [];
  List<FlashNotifications> _notifications = [];
  String _searchQuery = '';
  CategoryModel? _selectedCategory;
  late final AnimationController _headerCtrl;
  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool _searchFocused = false;

  @override
  void initState() {
    super.initState();

    _headerCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _headerFade =
        CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOutCubic));

    _searchFocus.addListener(() {
      if (mounted) setState(() => _searchFocused = _searchFocus.hasFocus);
    });

    _loadUser();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _headerCtrl.forward();
      context.read<CategoryBloc>().add(FetchCategoriesEvent());
      context.read<PublicEventBloc>().add(GetPublicEvents());
      context.read<UpcomingEventBloc>().add(GetUpcomingEvents());
      context.read<NotificationsBloc>().add(FetchNotificationsEvent());
    });
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final isLoggedIn = await UserPreferences().getLoginStatus();
    if (!isLoggedIn && mounted) {
      context.pushReplacementNamed('login');
      return;
    }
    final n = UserPreferences().getUserName().toString().split(' ').first;
    final id = UserPreferences().getUserId().toString();
    if (mounted) setState(() { _name = n; _userId = id; });
  }

  List<EventDataModel> _filtered(List<EventDataModel> events) {
    var result = events;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((e) =>
          e.name.toLowerCase().contains(q) ||
          e.venue.toLowerCase().contains(q) ||
          e.category.name.toLowerCase().contains(q)).toList();
    }
    if (_selectedCategory != null) {
      result = result
          .where((e) => e.category.id == _selectedCategory!.id)
          .toList();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          // ── Gradient collapsing header ──────────────────────────────────
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 115,
            elevation: 0,
            backgroundColor: AppColors.headerStart,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: SlideTransition(
                position: _headerSlide,
                child: FadeTransition(
                  opacity: _headerFade,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.headerStart,
                          Color(0xFF14063A),
                          AppColors.headerEnd,
                        ],
                        stops: [0.0, 0.55, 1.0],
                      ),
                    ),
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 18,
                      left: 22,
                      right: 22,
                      bottom: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              getTimeOfDayGreeting(context),
                              style: GoogleFonts.inter(
                                color: Colors.white.withValues(alpha: 0.60),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _name.isEmpty ? 'Welcome 👋' : _name,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                                height: 1.15,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                        PressScale(
                          onTap: () =>
                              context.pushNamed('pending_invitations'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withValues(alpha: 0.45),
                                  AppColors.primary.withValues(alpha: 0.25),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.55),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.mail_outline_rounded,
                                    color: Colors.white, size: 15),
                                const SizedBox(width: 6),
                                Text(
                                  'Invites',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Search bar ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 50,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _searchFocused
                        ? AppColors.primary.withValues(alpha: 0.7)
                        : theme.colorScheme.outline.withValues(alpha: 0.18),
                    width: _searchFocused ? 1.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _searchFocused
                          ? AppColors.primary.withValues(alpha: 0.10)
                          : Colors.black.withValues(alpha: 0.06),
                      blurRadius: _searchFocused ? 14 : 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.search_rounded,
                          key: ValueKey(_searchFocused),
                          color: _searchFocused
                              ? AppColors.primary
                              : theme.colorScheme.outline,
                          size: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        focusNode: _searchFocus,
                        onChanged: (q) => setState(() => _searchQuery = q),
                        style: GoogleFonts.inter(
                          color: theme.colorScheme.onSurface,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search events, venues…',
                          hintStyle: GoogleFonts.inter(
                            color: theme.colorScheme.outline,
                            fontSize: 14.sp,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchCtrl.clear();
                          setState(() => _searchQuery = '');
                          _searchFocus.unfocus();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // ── Quick actions ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: FadeSlideItem(
              index: 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _QuickAction(
                      icon: Icons.add_circle_outline_rounded,
                      label: 'Create',
                      color: AppColors.primary,
                      onTap: () => context.pushNamed('create_event'),
                    ),
                    _QuickAction(
                      icon: Icons.bookmark_outline_rounded,
                      label: 'Saved',
                      color: AppColors.accentAmber,
                      onTap: () => context.pushNamed('bookmarks'),
                    ),
                    _QuickAction(
                      icon: Icons.group_outlined,
                      label: 'Groups',
                      color: AppColors.accentEmerald,
                      onTap: () => context.pushNamed('groups'),
                    ),
                    _QuickAction(
                      icon: Icons.mood_outlined,
                      label: 'Mood',
                      color: AppColors.accentCyan,
                      onTap: () => context.pushNamed('mood'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Upcoming events ─────────────────────────────────────────────
          BlocBuilder<UpcomingEventBloc, EventListState>(
            builder: (context, state) {
              if (state is EventListLoading || state is EventListInitial) {
                return SliverToBoxAdapter(
                  child: _SkeletonSection(label: lang.upcomingEvents),
                );
              }
              if (state is EventListLoaded) {
                _upcomingEvents = state.events.reversed.toList();
              }
              if (_upcomingEvents.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
              return SliverToBoxAdapter(
                child: FadeSlideItem(
                  index: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        title: lang.upcomingEvents,
                        onSeeAll: null,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.24,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          physics: const BouncingScrollPhysics(),
                          itemCount: _upcomingEvents.length,
                          itemBuilder: (context, index) {
                            final event = _upcomingEvents[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: PressScale(
                                onTap: () => context.pushNamed(
                                  'event_details',
                                  extra: {
                                    'eventId': event.id,
                                    'isOwnEvent':
                                        event.user?.uuid == _userId,
                                  },
                                ),
                                child: UpcomingEventListTemplate(
                                  eventName: event.name,
                                  eventImageString: event.image,
                                  eventDay: getDayName(event.date),
                                  eventDate: convertDateDotFormat(
                                      DateTime.parse(event.date)),
                                  eventId: event.id,
                                  eventLocation: event.venue,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          ),

          // ── Flash notifications ─────────────────────────────────────────
          BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              if (state is NotificationsLoadedState &&
                  state.notifications.isNotEmpty) {
                _notifications = state.notifications;
                return SliverToBoxAdapter(
                  child: FadeSlideItem(
                    index: 2,
                    child: SizedBox(
                      height: 88,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _notifications.length > 3
                            ? 3
                            : _notifications.length,
                        itemBuilder: (context, index) =>
                            Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: _FlashNotificationCard(
                            notification: _notifications[index],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),

          // ── Groups CTA ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: FadeSlideItem(
              index: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: PressScale(
                  onTap: () => context.pushNamed('groups'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1E1040), Color(0xFF2D1560)],
                      ),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.group_rounded,
                              color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Groups',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                    color: Colors.white,
                                  )),
                              Text('Discover and join communities',
                                  style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      color: Colors.white60)),
                            ],
                          ),
                        ),
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_forward_ios_rounded,
                              color: AppColors.primary, size: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Explore + category pills ─────────────────────────────────────
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoadingState) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                    child: Row(
                      children: List.generate(
                        4,
                        (i) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ShimmerBox(
                              width: 72, height: 32, borderRadius: 20),
                        ),
                      ),
                    ),
                  ),
                );
              }
              final categories =
                  state is CategoryLoadedState ? state.categories : <CategoryModel>[];
              return SliverToBoxAdapter(
                child: FadeSlideItem(
                  index: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _SectionHeader(title: lang.explore, onSeeAll: null),
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          physics: const BouncingScrollPhysics(),
                          children: [
                            // "All" pill
                            _CategoryPill(
                              label: lang.all,
                              selected: _selectedCategory == null,
                              onTap: () =>
                                  setState(() => _selectedCategory = null),
                              primary: primary,
                            ),
                            ...categories.map((cat) => _CategoryPill(
                                  label: cat.name,
                                  selected: _selectedCategory?.id == cat.id,
                                  onTap: () {
                                    setState(() {
                                      _selectedCategory =
                                          _selectedCategory?.id == cat.id
                                              ? null
                                              : cat;
                                    });
                                    context.push('/category', extra: {
                                      'categoryId': cat.id,
                                      'categoryName': cat.name,
                                    });
                                  },
                                  primary: primary,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          ),

          // ── Public events feed ──────────────────────────────────────────
          BlocBuilder<PublicEventBloc, EventListState>(
            builder: (context, state) {
              if (state is EventListInitial || state is EventListLoading) {
                return SliverToBoxAdapter(child: _EventFeedSkeleton());
              }
              // Error: show cached data or friendly error state
              if (state is EventListError && _publicEvents.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 48),
                    child: Column(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(Icons.wifi_off_rounded,
                              size: 34,
                              color: theme.colorScheme.outline),
                        ),
                        const SizedBox(height: 16),
                        Text('Could not load events',
                            style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Text('Check your connection and pull to refresh',
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.outline),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        PressScale(
                          onTap: () => context
                              .read<PublicEventBloc>()
                              .add(GetPublicEvents()),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 10),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: primary.withValues(alpha: 0.3)),
                            ),
                            child: Text('Retry',
                                style: TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (state is EventListLoaded) {
                _publicEvents = state.events.reversed.toList();
              }
              final filtered = _filtered(_publicEvents);
              if (filtered.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 40),
                    child: Column(
                      children: [
                        Icon(Icons.search_off,
                            size: 48,
                            color: theme.colorScheme.outline),
                        const SizedBox(height: 12),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No events match "$_searchQuery"'
                              : 'No events yet',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.outline),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final event = filtered[index];
                    final isOwn = event.user?.uuid == _userId;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: FadeSlideItem(
                        index: index,
                        staggerStep: const Duration(milliseconds: 45),
                        child: PressScale(
                          onTap: () => context.pushNamed(
                            'event_details',
                            extra: {
                              'eventId': event.id,
                              'isOwnEvent': isOwn,
                            },
                          ),
                          child: EventCard(
                            showOwnerInfo: true,
                            eventOwner: event.username,
                            eventOwnerAvatar: event.user?.avatar,
                            eventName: event.name,
                            eventLocation: event.venue.split(',').first,
                            eventDay: getDayName(event.date),
                            eventDate: convertDateDotFormat(
                                DateTime.parse(event.date)),
                            eventImageString: event.image ?? '',
                            eventId: event.id,
                            hasLikedEvent: event.hasLikedEvent,
                            inviteStatus:
                                getInviteStatus(event, _userId),
                            showStatusBadge: false,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: filtered.length,
                ),
              );
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

// ── Section header ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'See all',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Quick action button ─────────────────────────────────────────────────────

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Animated category pill ──────────────────────────────────────────────────

class _CategoryPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color primary;

  const _CategoryPill({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: PressScale(
        onTap: onTap,
        pressedScale: 0.93,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? primary
                  : Theme.of(context).colorScheme.outline,
              width: selected ? 0 : 1,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Improved flash notification card ───────────────────────────────────────

class _FlashNotificationCard extends StatelessWidget {
  final FlashNotifications notification;

  const _FlashNotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return PressScale(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.72,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isDark
              ? const Color(0xFF1A2235)
              : theme.colorScheme.surface,
          border: Border.all(
            color: primary.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: primary),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    notification.headline,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              notification.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Skeleton loaders ────────────────────────────────────────────────────────

class _SkeletonSection extends StatelessWidget {
  final String label;

  const _SkeletonSection({required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
          child: ShimmerBox(width: 120, height: 16, borderRadius: 8),
        ),
        SizedBox(
          height: 170,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ShimmerBox(
                width: MediaQuery.of(context).size.width * 0.66,
                height: 170,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EventFeedSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Column(
      children: List.generate(
        2,
        (i) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const ShimmerBox(width: 36, height: 36, borderRadius: 18),
                const SizedBox(width: 10),
                ShimmerBox(width: 110, height: 13, borderRadius: 6),
              ]),
              const SizedBox(height: 10),
              ShimmerBox(
                  width: w - 40,
                  height: (w - 40) * 9 / 16,
                  borderRadius: 12),
              const SizedBox(height: 10),
              ShimmerBox(width: w * 0.65, height: 14, borderRadius: 6),
              const SizedBox(height: 6),
              ShimmerBox(width: w * 0.40, height: 11, borderRadius: 6),
            ],
          ),
        ),
      ),
    );
  }
}
