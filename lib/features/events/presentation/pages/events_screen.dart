import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/date_formatters.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/core/widgets/epmty_list_view.dart';
import 'package:rapidlie/core/widgets/general_event_list_template.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/features/events/presentation/pages/create_event/create_event_screen.dart';
import 'package:rapidlie/features/events/presentation/pages/event_details_screen.dart';
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

  @override
  void initState() {
    _pageViewController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<PrivateEventBloc>().add(GetPrivateEvents());
    language = AppLocalizations.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBarTemplate(
            pageTitle: language.events,
            isSubPage: false,
          ),
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        floatingActionButton: floatingActionButton(),
        body: SingleChildScrollView(
          child: BlocBuilder<PrivateEventBloc, PrivateEventState>(
            builder: (context, state) {
              if (state is InitialPrivateEventState) {
                return emptyStateFullView(
                  headerText: "No events",
                  bodyText:
                      "Get started by hitting the button on the bottom right corner of your screen. It is easy",
                );
              } else if (state is PrivateEventLoading) {
                return Center(child: CupertinoActivityIndicator());
              } else if (state is PrivateEventLoaded) {
                return buildBody(state.events.reversed.toList());
              }
              return Center(
                  child: Text(
                "Empty",
                style: TextStyle(fontSize: 30),
              ));
            },
          ),
        ),
      ),
    );
  }

  Container buildBody(List<EventDataModel> eventDataModel) {
    return Container(
      height: height,
      width: width,
      child: eventDataModel.length == 0
          ? emptyStateFullView(
              headerText: "No events",
              bodyText:
                  "Get started by hitting the button on the bottom right corner of your screen. It is easy",
            )
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
                      Get.to(
                        () => EventDetailsScreeen(
                          isOwnEvent: true,
                        ),
                        arguments: eventDataModel[index],
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
      onTap: () => Get.to(
        () => CreateEventScreen(),
      ),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
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
      print("Error converting image to Base64: $e");
      return null;
    }
  }
}
