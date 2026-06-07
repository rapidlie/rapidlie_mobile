import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/core/utils/date_formatters.dart';
import 'package:rapidlie/core/utils/get_invite_status.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/core/widgets/epmty_list_view.dart';
import 'package:rapidlie/core/widgets/event_card.dart';
import 'package:rapidlie/features/bookmarks/blocs/bookmark_bloc/bookmark_bloc.dart';
import 'package:rapidlie/features/events/models/event_model.dart';

class BookmarkedEventsScreen extends StatefulWidget {
  const BookmarkedEventsScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkedEventsScreen> createState() => _BookmarkedEventsScreenState();
}

class _BookmarkedEventsScreenState extends State<BookmarkedEventsScreen> {
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = UserPreferences().getUserId().toString();
    context.read<BookmarkBloc>().add(const FetchBookmarkedEvents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBarTemplate(pageTitle: 'Bookmarks', isSubPage: true),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async =>
              context.read<BookmarkBloc>().add(const FetchBookmarkedEvents()),
          child: BlocBuilder<BookmarkBloc, BookmarkState>(
            builder: (context, state) {
              if (state is BookmarkLoading || state is BookmarkInitial) {
                return emptyListWithShimmer();
              }
              if (state is BookmarkedEventsLoaded) {
                if (state.events.isEmpty) return emptyStateView();
                return _EventList(events: state.events, userId: userId);
              }
              if (state is BookmarkError) {
                return Center(child: Text(state.message));
              }
              return emptyListWithShimmer();
            },
          ),
        ),
      ),
    );
  }
}

class _EventList extends StatelessWidget {
  final List<EventDataModel> events;
  final String userId;

  const _EventList({required this.events, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: GestureDetector(
            onTap: () {
              final isOwnEvent = event.user?.uuid == userId;
              context.pushNamed(
                'event_details',
                extra: {'eventId': event.id, 'isOwnEvent': isOwnEvent},
              );
            },
            child: EventCard(
              showOwnerInfo: true,
              eventOwner: event.username,
              eventName: event.name,
              eventLocation: event.venue.split(',').first,
              eventDay: getDayName(event.date),
              eventDate: convertDateDotFormat(DateTime.parse(event.date)),
              eventImageString: event.image ?? '',
              eventId: event.id,
              hasLikedEvent: event.hasLikedEvent,
              eventOwnerAvatar: event.user?.avatar,
              inviteStatus: getInviteStatus(event, userId),
              showStatusBadge: false,
            ),
          ),
        );
      },
    );
  }
}
