import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';
import 'package:rapidlie/core/utils/date_formatters.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';
import 'package:rapidlie/features/events/blocs/like_bloc/like_event_bloc.dart';
import 'package:rapidlie/features/events/blocs/like_bloc/like_event_state.dart';
import 'package:rapidlie/features/events/presentation/pages/event_details_screen.dart';
import 'package:rapidlie/features/home/presentation/widgets/event_list_template.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class InvitesScreen extends StatefulWidget {
  static const String routeName = "invites";

  @override
  State<InvitesScreen> createState() => _InvitesScreenState();
}

class _InvitesScreenState extends State<InvitesScreen>
    with AutomaticKeepAliveClientMixin {
  var language;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    final bloc = context.read<PrivateEventBloc>();
    if (bloc.state is! PrivateEventLoaded) {
      bloc.add(GetPrivateEvents());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: BlocListener<LikeEventBloc, LikeEventState>(
              listener: (context, state) {
                if (state is LikeEventLoaded) {
                  context
                      .read<PrivateEventBloc>()
                      .add(GetPrivateEvents()); // Reload specific events
                }
              },
              child: BlocBuilder<PrivateEventBloc, PrivateEventState>(
                builder: (context, state) {
                  if (state is InitialPrivateEventState) {
                    return Text(
                      "No invites",
                      textAlign: TextAlign.center,
                      style: poppins13black400(),
                    );
                  } else if (state is PrivateEventLoading) {
                    return Center(child: CupertinoActivityIndicator());
                  }
                  if (state is PrivateEventLoaded) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.events.length,
                      physics: BouncingScrollPhysics(
                          parent: NeverScrollableScrollPhysics()),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(
                                () => EventDetailsScreeen(isOwnEvent: false),
                                arguments: state.events[index],
                              );
                            },
                            child: EventListTemplate(
                              eventOwner: state.events[index].username,
                              eventName: state.events[index].name,
                              eventLocation: state.events[index].venue,
                              eventDay: getDayName(state.events[index].date),
                              eventDate: convertDateDotFormat(
                                  DateTime.parse(state.events[index].date)),
                              eventImageString: state.events[index].image!,
                              eventId: state.events[index].id,
                              hasLikedEvent: state.events[index].hasLikedEvent,
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
          )),
    );
  }
}
