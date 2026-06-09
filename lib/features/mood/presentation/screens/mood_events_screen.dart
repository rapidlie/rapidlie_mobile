import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/utils/app_theme.dart';
import 'package:rapidlie/core/utils/date_formatters.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/core/widgets/animations.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/core/widgets/event_card.dart';
import 'package:rapidlie/features/mood/blocs/mood_bloc/mood_bloc.dart';

class MoodEventsScreen extends StatelessWidget {
  const MoodEventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = UserPreferences().getUserId().toString();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: 'Events For Your Vibe',
          isSubPage: true,
          trailingWidget: GestureDetector(
            onTap: () => context.pushNamed('mood'),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                'Change Vibe',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<MoodBloc, MoodState>(
        builder: (context, state) {
          if (state is MoodLoading) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, __) => ShimmerBox(
                width: double.infinity,
                height: 200,
                borderRadius: 16,
              ),
            );
          }

          if (state is MoodError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sentiment_dissatisfied_rounded,
                      size: 54,
                      color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 12),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        color: Theme.of(context).colorScheme.outline),
                  ),
                  const SizedBox(height: 16),
                  PressScale(
                    onTap: () => context
                        .read<MoodBloc>()
                        .add(const FetchMoodSuggestions()),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.darkCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFF3C3C3C), width: 1),
                      ),
                      child: Text(
                        'Retry',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is MoodSuggestionsLoaded) {
            final events = state.events;
            if (events.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.mood_bad_rounded,
                        size: 54,
                        color: Theme.of(context).colorScheme.outline),
                    const SizedBox(height: 12),
                    Text(
                      'No events match your vibe right now.',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Check back later or change your vibe!',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.outline),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => context
                  .read<MoodBloc>()
                  .add(const FetchMoodSuggestions()),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                itemCount: events.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, i) {
                  final e = events[i];
                  final isOwn = e.user?.uuid == userId;
                  return FadeSlideItem(
                    index: i,
                    child: PressScale(
                      onTap: () => context.pushNamed(
                        'event_details',
                        extra: {
                          'eventId': e.id,
                          'isOwnEvent': isOwn,
                        },
                      ),
                      child: EventCard(
                        eventName: e.name,
                        eventDate: convertDateDotFormat(
                            DateTime.parse(e.date)),
                        eventDay: getDayName(e.date),
                        inviteStatus: '',
                        eventImageString: e.image,
                        eventId: e.id,
                        eventOwner: e.username,
                        eventOwnerAvatar: e.user?.avatar,
                        eventLocation: e.venue,
                        hasLikedEvent: false,
                        showStatusBadge: false,
                        showOwnerInfo: true,
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Center(
            child: Text(
              'Loading your mood events...',
              style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.outline),
            ),
          );
        },
      ),
    );
  }
}
