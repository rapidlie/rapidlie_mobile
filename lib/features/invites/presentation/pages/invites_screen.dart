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
import 'package:rapidlie/features/home/presentation/widgets/event_list_template.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class InvitesScreen extends StatefulWidget {
  static const String routeName = "invites";

  @override
  State<InvitesScreen> createState() => _InvitesScreenState();
}

class _InvitesScreenState extends State<InvitesScreen> {
  var language;
  late String userId;

  @override
  void initState() {
    getUserID();
    super.initState();
  }

  void getUserID() async {
    userId = UserPreferences().getUserId().toString();
  }

  Future<void> _handleRefresh() async {
    context.read<InvitedEventBloc>().add(GetInvitedEvents());
    context.read<UpcomingEventBloc>().add(GetUpcomingEvents());
    context.read<PublicEventBloc>().add(GetPublicEvents());
    context.read<PrivateEventBloc>().add(GetPrivateEvents());
  }

  @override
  Widget build(BuildContext context) {
    context.read<InvitedEventBloc>().add(GetInvitedEvents());
    language = AppLocalizations.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBarTemplate(
            pageTitle: language.invites,
            isSubPage: false,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            child: BlocBuilder<InvitedEventBloc, InvitedEventState>(
              builder: (context, state) {
                if (state is InitialInvitedEventState) {
                  return emptyListWithShimmer();
                } else if (state is InvitedEventLoading) {
                  return emptyListWithShimmer();
                }
                if (state is InvitedEventLoaded) {
                  return buildBody(state.events.reversed.toList());
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBody(List<EventDataModel> eventDataModel) {
    return eventDataModel.length == 0
        ? emptyStateView()
        : ListView.builder(
            shrinkWrap: true,
            itemCount: eventDataModel.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: GestureDetector(
                  onTap: () {
                    bool isOwnEvent =
                        eventDataModel[index].user!.uuid == userId;
                    context.pushNamed(
                      'event_details',
                      extra: {
                        'eventId': eventDataModel[index].id,
                        'isOwnEvent': isOwnEvent,
                      },
                    );
                  },
                  child: EventListTemplate(
                    eventOwner: eventDataModel[index].username,
                    eventName: eventDataModel[index].name,
                    eventLocation: eventDataModel[index].venue.split(",").first,
                    eventDay: getDayName(eventDataModel[index].date),
                    eventDate: convertDateDotFormat(
                        DateTime.parse(eventDataModel[index].date)),
                    eventImageString: eventDataModel[index].image!,
                    eventId: eventDataModel[index].id,
                    hasLikedEvent: eventDataModel[index].hasLikedEvent,
                    eventOwnerAvatar: eventDataModel[index].user!.avatar,
                    inviteStatus:
                        getInviteStatus(eventDataModel[index], userId),
                    showStatusBadge: true,
                  ),
                ),
              );
            },
          );
  }
}
