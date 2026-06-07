import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/core/widgets/event_card.dart';
import 'package:rapidlie/features/mood/blocs/mood_bloc/mood_bloc.dart';

class MoodEventsScreen extends StatelessWidget {
  const MoodEventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events For Your Vibe'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pushNamed('mood'),
            child: const Text('Change Vibe'),
          ),
        ],
      ),
      body: BlocBuilder<MoodBloc, MoodState>(
        builder: (context, state) {
          if (state is MoodLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MoodError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context
                        .read<MoodBloc>()
                        .add(const FetchMoodSuggestions()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is MoodSuggestionsLoaded) {
            final events = state.events;
            if (events.isEmpty) {
              return const Center(
                child: Text(
                    'No events match your vibe right now.\nCheck back later!',
                    textAlign: TextAlign.center),
              );
            }
            return RefreshIndicator(
              onRefresh: () async => context
                  .read<MoodBloc>()
                  .add(const FetchMoodSuggestions()),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: events.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final e = events[i];
                  return EventCard(
                    eventName: e.name,
                    eventDate: e.date,
                    eventDay: e.date,
                    inviteStatus: '',
                    eventImageString: e.image,
                    eventId: e.id,
                    eventOwner: e.username,
                    eventOwnerAvatar: e.user?.avatar,
                    eventLocation: e.venue,
                    hasLikedEvent: false,
                    showStatusBadge: false,
                    showOwnerInfo: true,
                  );
                },
              ),
            );
          }
          return const Center(child: Text('Loading your mood events...'));
        },
      ),
    );
  }
}
