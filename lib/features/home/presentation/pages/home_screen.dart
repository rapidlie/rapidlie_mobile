import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/date_formatters.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/core/widgets/epmty_list_view.dart';
import 'package:rapidlie/features/categories/bloc/category_bloc.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';
import 'package:rapidlie/features/events/presentation/pages/event_details_screen.dart';
import 'package:rapidlie/features/home/presentation/widgets/event_list_template.dart';
import 'package:rapidlie/features/home/presentation/widgets/explore_categories_list_template.dart';
import 'package:rapidlie/features/home/presentation/widgets/upcoming_event_list_template.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  
  var language;
  String name = "";

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    getUserName();
    final bloc1 = context.read<CategoryBloc>();
    final bloc2 = context.read<PublicEventBloc>();
    final bloc3 = context.read<UpcomingEventBloc>();
    if (bloc3.state is! UpcomingEventLoaded) {
      bloc1.add(FetchCategoriesEvent());
      bloc2.add(GetPublicEvents());
      bloc3.add(GetUpcomingEvents());
    }
    super.initState();
  }

  void getUserName() async {
    name = UserPreferences().getUserName().toString().split(' ').first;
    print(UserPreferences().getBearerToken());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    language = AppLocalizations.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBarTemplate(
            pageTitle: language.hi + " " + name,
            isSubPage: false,
          ),
        ),
        body: SingleChildScrollView(
          
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    language.upcomingEvents,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                verySmallHeight(),
                BlocBuilder<UpcomingEventBloc, UpcomingEventState>(
                    builder: (context, state) {
                  if (state is InitialUpcomingEventState) {
                    return Text('No upcoming events at the moment');
                  } else if (state is UpcomingEventLoading) {
                    return Text('No upcoming events at the moment');
                  } else if (state is UpcomingEventLoaded) {
                    return Container(
                      width: width,
                      height: height * 0.25,
                      child: state.events.isEmpty
                          ? emptyStateSingleView(
                              "Accepts invitations to see upcoming events here,")
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 70),
                              physics: AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics()),
                              itemCount: state.events.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => EventDetailsScreeen(
                                        isOwnEvent: true,
                                      ),
                                      arguments: state.events[index],
                                    );
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 40.0),
                                    child: UpcomingEventListTemplate(
                                      eventName: state.events[index].name,
                                      eventImageString:
                                          state.events[index].image,
                                      eventDay:
                                          getDayName(state.events[index].date),
                                      eventDate: convertDateDotFormat(
                                        DateTime.parse(
                                            state.events[index].date),
                                      ),
                                      eventId: state.events[index].id,
                                      eventLocation: state.events[index].venue,
                                    ),
                                  ),
                                );
                              },
                            ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        'No upcoming events at the moment',
                        style: poppins13black400(),
                      ),
                    );
                  }
                }),
                bigHeight(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    language.explore,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                verySmallHeight(),
                Container(
                  width: width,
                  height: 80,
                  child: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoadingState) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is CategoryLoadedState) {
                        return ListView.builder(
                          itemCount: state.categories.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(left: 10),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 0),
                              child: ExploreCategoryListTemplate(
                                categoryName: state.categories[index].name,
                                imageSrc: state.categories[index].image,
                              ),
                            );
                          },
                        );
                      } else if (state is CategoryErrorState) {
                        return Center(child: Text('Failed to load categories'));
                      }
                      return Center(child: Text('No categories found'));
                    },
                  ),
                ),
                //bigHeight(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    language.discover,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                verySmallHeight(),
                BlocBuilder<PublicEventBloc, PublicEventState>(
                  builder: (context, state) {
                    if (state is InitialPublicEventState) {
                      return Text(
                        "No invites",
                        textAlign: TextAlign.center,
                        style: poppins13black400(),
                      );
                    } else if (state is PublicEventLoading) {
                      return Center(child: CupertinoActivityIndicator());
                    } else if (state is PublicEventLoaded) {
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
                                Get.to(
                                    () =>
                                        EventDetailsScreeen(isOwnEvent: false),
                                    arguments: state.events[index]);
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
                                hasLikedEvent:
                                    state.events[index].hasLikedEvent,
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
