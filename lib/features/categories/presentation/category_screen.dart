import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/core/utils/date_formatters.dart';
import 'package:rapidlie/core/utils/get_invite_status.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/core/widgets/epmty_list_view.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/features/events/repository/event_respository.dart';
import 'package:rapidlie/features/home/presentation/widgets/event_list_template.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const CategoryScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  static CategoryScreen fromState(GoRouterState state) {
    final data = state.extra as Map<String, dynamic>;
    return CategoryScreen(
      categoryId: data['categoryId'],
      categoryName: data['categoryName'],
    );
  }

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late String userId;

  var language;

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) =>
          EventByCategoryBloc(eventRepository: context.read<EventRepository>())
            ..add(GetEventsByCategory(widget.categoryId)),
      child: EventsByCategoryView(
        pageTitle: widget.categoryName,
      ),
    );
  }
}

class EventsByCategoryView extends StatefulWidget {
  final String pageTitle;
  const EventsByCategoryView({
    Key? key,
    required this.pageTitle,
  }) : super(key: key);

  @override
  State<EventsByCategoryView> createState() => _EventsByCategoryViewState();
}

class _EventsByCategoryViewState extends State<EventsByCategoryView> {
  late String userId;

  @override
  void initState() {
    getUserID();
    super.initState();
  }

  getUserID() async {
    userId = UserPreferences().getUserId().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: widget.pageTitle,
          isSubPage: true,
        ),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<EventByCategoryBloc, EventByCategoryState>(
          builder: (context, state) {
            if (state is InitialEventByCategoryState) {
              return emptyListWithShimmer();
            } else if (state is EventByCategoryLoading) {
              return emptyListWithShimmer();
            } else if (state is EventByCategoryLoaded) {
              return buildBody(state.events.reversed.toList());
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget buildBody(List<EventDataModel> events) {
    return events.length == 0
        ? emptyStateView()
        : ListView.builder(
            shrinkWrap: true,
            itemCount: events.length,
            //controller: _scrollController,
            physics: BouncingScrollPhysics(
                parent: BouncingScrollPhysics(
              parent: NeverScrollableScrollPhysics(),
            )),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: GestureDetector(
                  onTap: () {
                    final inviteStatus = getInviteStatus(events[index], userId);
                    bool isOwnEvent = events[index].user!.uuid == userId;
                    context.pushNamed(
                      'event_details',
                      extra: {
                        'eventId': events[index].id,
                        'isOwnEvent': isOwnEvent,
                      },
                    );
                  },
                  child: EventListTemplate(
                    eventOwner: events[index].username,
                    eventName: events[index].name,
                    eventLocation: events[index].venue.split(',').first,
                    eventDay: getDayName(events[index].date),
                    eventDate: convertDateDotFormat(
                        DateTime.parse(events[index].date)),
                    eventImageString: events[index].image!,
                    eventId: events[index].id,
                    hasLikedEvent: events[index].hasLikedEvent,
                    eventOwnerAvatar: events[index].user!.avatar,
                    inviteStatus: getInviteStatus(events[index], userId),
                    showStatusBadge: false,
                  ),
                ),
              );
            },
          );
  }
}
