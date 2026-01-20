import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/core/utils/date_formatters.dart';
import 'package:rapidlie/core/utils/get_invite_status.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/core/widgets/epmty_list_view.dart';
import 'package:rapidlie/core/widgets/general_event_list_template.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class EventsScreen extends StatefulWidget {
  static const String routeName = "events";

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late PageController _pageViewController;
  bool publicEvent = false;
  var language;
  late String userId;

  @override
  void initState() {
    _pageViewController = PageController();
    getUserID();
    super.initState();
  }

  void getUserID() async {
    userId = UserPreferences().getUserId().toString();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    context.read<PrivateEventBloc>().add(GetPrivateEvents());
  }

  @override
  Widget build(BuildContext context) {
    context.read<PrivateEventBloc>().add(GetPrivateEvents());
    language = AppLocalizations.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: language.myEvents,
          isSubPage: false,
        ),
      ),
      resizeToAvoidBottomInset: true,
      floatingActionButton: floatingActionButton(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            child: BlocBuilder<PrivateEventBloc, PrivateEventState>(
              builder: (context, state) {
                if (state is InitialPrivateEventState) {
                  return emptyListWithShimmer();
                } else if (state is PrivateEventLoading) {
                  return emptyListWithShimmer();
                } else if (state is PrivateEventLoaded) {
                  return buildBody(
                      state.events.reversed.toList(), width, height);
                }
                return emptyListWithShimmer();
              },
            ),
          ),
        ),
      ),
    );
  }

  Container buildBody(List<EventDataModel> eventDataModel, width, height) {
    return Container(
      height: height,
      width: width,
      child: eventDataModel.length == 0
          ? emptyStateView()
          : Padding(
              padding: const EdgeInsets.only(bottom: 200.0),
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 70),
                physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                itemCount: eventDataModel.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      /* final inviteStatus =
                          getInviteStatus(eventDataModel[index], userId); */
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
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: GeneralEventListTemplate(
                        eventName: eventDataModel[index].name,
                        eventImageString: eventDataModel[index].image,
                        eventDay: getDayName(eventDataModel[index].date),
                        eventDate: convertDateDotFormat(
                          DateTime.parse(eventDataModel[index].date),
                        ),
                        eventId: eventDataModel[index].id,
                        hasLikedEvent: eventDataModel[index].hasLikedEvent,
                        inviteStatus:
                            getInviteStatus(eventDataModel[index], userId),
                        showStatusBadge: false,
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget floatingActionButton() {
    return GestureDetector(
      onTap: () => context.pushNamed('create_event'),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 30,
        ),
      ),
    );
  }

  Future<String?> convertImageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      return null;
    }
  }
}
