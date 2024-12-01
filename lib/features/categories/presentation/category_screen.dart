// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:rapidlie/core/utils/date_formatters.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/core/widgets/epmty_list_view.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';
import 'package:rapidlie/features/events/presentation/pages/event_details_screen.dart';
import 'package:rapidlie/features/events/repository/event_respository.dart';
import 'package:rapidlie/features/home/presentation/widgets/event_list_template.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class CategoryScreen extends StatelessWidget {
  static const String routeName = "category";

  List<String> arguments = Get.arguments;

  var language;

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) =>
          EventByCategoryBloc(eventRepository: context.read<EventRepository>())
            ..add(GetEventsByCategory(arguments[0])),
      child: EventsByCategoryView(
        pageTitle: arguments[1],
      ),
    );
  }
}

class EventsByCategoryView extends StatelessWidget {
  final String pageTitle;
  const EventsByCategoryView({
    Key? key,
    required this.pageTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: pageTitle,
          isSubPage: true,
        ),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<EventByCategoryBloc, EventByCategoryState>(
          builder: (context, state) {
            if (state is InitialEventByCategoryState) {
              return emptyStateCategoryView();
            } else if (state is EventByCategoryLoading) {
              return Center(child: CupertinoActivityIndicator());
            } else if (state is EventByCategoryLoaded) {
              if (state.events.isEmpty) {
                return emptyStateCategoryView();
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.events.length,
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
                        Get.to(() => EventDetailsScreeen(isOwnEvent: false),
                            arguments: state.events[index]);
                      },
                      child: EventListTemplate(
                        eventOwner: state.events[index].username,
                        eventName: state.events[index].name,
                        eventLocation:
                            state.events[index].venue.split(',').first,
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
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}




/* 



 */
