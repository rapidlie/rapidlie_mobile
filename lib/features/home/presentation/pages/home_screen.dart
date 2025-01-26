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
import 'package:rapidlie/core/widgets/header_title_template.dart';
import 'package:rapidlie/features/categories/bloc/category_bloc.dart';
import 'package:rapidlie/features/categories/presentation/category_screen.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';
import 'package:rapidlie/features/events/presentation/pages/event_details_screen.dart';
import 'package:rapidlie/features/home/presentation/widgets/event_list_template.dart';
import 'package:rapidlie/features/home/presentation/widgets/explore_categories_list_template.dart';
import 'package:rapidlie/features/home/presentation/widgets/upcoming_event_list_template.dart';
import 'package:rapidlie/features/login/presentation/pages/login_screen.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var language;
  String name = "";

  @override
  void initState() {
    getUserName();
    checkLoggedInStatus();
    context.read<CategoryBloc>().add(FetchCategoriesEvent());
    context.read<PublicEventBloc>().add(GetPublicEvents());
    context.read<UpcomingEventBloc>().add(GetUpcomingEvents());
    super.initState();
  }

  void getUserName() async {
    name = UserPreferences().getUserName().toString().split(' ').first;
  }

  void checkLoggedInStatus() async {
    if (await UserPreferences().getLoginStatus() == false) {
      Get.to(() => LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    return emptyStateSingleView();
                  } else if (state is UpcomingEventLoading) {
                    return Center(child: CupertinoActivityIndicator());
                  } else if (state is UpcomingEventLoaded) {
                    return Container(
                      width: width,
                      height: height * 0.25,
                      child: state.events.isEmpty
                          ? emptyStateSingleView()
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              //padding: const EdgeInsets.only(bottom: 70),
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
                                  child: UpcomingEventListTemplate(
                                    eventName: state.events[index].name,
                                    eventImageString: state.events[index].image,
                                    eventDay:
                                        getDayName(state.events[index].date),
                                    eventDate: convertDateDotFormat(
                                      DateTime.parse(state.events[index].date),
                                    ),
                                    eventId: state.events[index].id,
                                    eventLocation: state.events[index].venue,
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
                  height: 50,
                  child: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoadingState) {
                        return Center(
                          child: CupertinoActivityIndicator(),
                        );
                      } else if (state is CategoryLoadedState) {
                        return ListView.builder(
                          itemCount: state.categories.length + 1,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(left: 10),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Column(
                                  children: [
                                    HeaderTextTemplate(
                                      titleText: "All",
                                      titleTextColor: Colors.white,
                                      containerColor: Colors.black,
                                      containerBorderColor: Colors.black,
                                      textSize: 12,
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(right: 0),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => CategoryScreen(), arguments: [
                                      state.categories[index - 1].id,
                                      state.categories[index - 1].name,
                                    ]);
                                  },
                                  child: ExploreCategoryListTemplate(
                                    categoryName:
                                        state.categories[index - 1].name,
                                    imageSrc: state.categories[index - 1].image,
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      } else if (state is CategoryErrorState) {
                        return Center(child: Text('Failed to load categories'));
                      }
                      return Center(child: Text('No categories found'));
                    },
                  ),
                ),
                verySmallHeight(),
                BlocBuilder<PublicEventBloc, PublicEventState>(
                  builder: (context, state) {
                    if (state is InitialPublicEventState) {
                      return emptyStateCategoryView();
                    } else if (state is PublicEventLoading) {
                      return Center(child: CupertinoActivityIndicator());
                    } else if (state is PublicEventLoaded) {
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
                                Get.to(
                                    () => EventDetailsScreeen(
                                        isOwnEvent:
                                            state.events[index].user!.uuid ==
                                                UserPreferences().getUserId()),
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
                                hasLikedEvent:
                                    state.events[index].hasLikedEvent,
                                eventOwnerAvatar:
                                    state.events[index].user!.avatar,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
