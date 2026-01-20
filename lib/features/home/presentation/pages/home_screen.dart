import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
 import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/date_formatters.dart';
import 'package:rapidlie/core/utils/get_invite_status.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/core/utils/time_of_day.dart';
import 'package:rapidlie/core/widgets/epmty_list_view.dart';
import 'package:rapidlie/core/widgets/header_title_template.dart';
import 'package:rapidlie/features/categories/bloc/category_bloc.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/features/home/bloc/notifications_bloc.dart';
import 'package:rapidlie/features/home/models/notification.dart';
import 'package:rapidlie/features/home/presentation/widgets/event_list_template.dart';
import 'package:rapidlie/features/home/presentation/widgets/explore_categories_list_template.dart';
import 'package:rapidlie/features/home/presentation/widgets/notifications_widget.dart';
import 'package:rapidlie/features/home/presentation/widgets/upcoming_event_list_template.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var language;
  String name = "Eugene";
  List<EventDataModel> publicEvents = [];
  List<EventDataModel> upcomingEvents = [];
  List<FlashNotifications> flashNotifications = [];
  late String userId;

  @override
  void initState() {
    getUserName();
    getUserID();
    checkLoggedInStatus();  
    super.initState();
  }

  void getUserName() async {
    name = UserPreferences().getUserName().toString().split(' ').first;
  }

  void getUserID() async {
    userId = UserPreferences().getUserId().toString();
  }

  void checkLoggedInStatus() async {
    if (await UserPreferences().getLoginStatus() == false) {
      context.pushReplacementNamed('login');
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<CategoryBloc>().add(FetchCategoriesEvent());
    context.read<PublicEventBloc>().add(GetPublicEvents());
    context.read<UpcomingEventBloc>().add(GetUpcomingEvents());
    context.read<NotificationsBloc>().add(FetchNotificationsEvent());
    language = AppLocalizations.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          /* child: AppBarTemplate(
            pageTitle: getTimeOfDayGreeting(context) + " " + name,
            isSubPage: false,
          ), */
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Text(
                      getTimeOfDayGreeting(context) + " " + name,
                      style: GoogleFonts.inter(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        textStyle: TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                BlocBuilder<UpcomingEventBloc, UpcomingEventState>(
                    builder: (context, state) {
                    
                    
                  if (state is InitialUpcomingEventState) {
                    return emptyListWithShimmer();
                  } else if (state is UpcomingEventLoading) {
                    return emptyListWithShimmer();
                  } else if (state is UpcomingEventLoaded) {
                    upcomingEvents = state.events.reversed.toList();

                    return upcomingEvents.isEmpty
                        ? SizedBox.shrink()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  language.upcomingEvents,
                                  style: inter16Black600(context),
                                ),
                              ),
                              verySmallHeight(),
                              Container(
                                width: width,
                                height: height * 0.25,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  //padding: const EdgeInsets.only(bottom: 70),
                                  physics: AlwaysScrollableScrollPhysics(
                                      parent: BouncingScrollPhysics()),
                                  itemCount: upcomingEvents.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        bool isOwnEvent =
                                            upcomingEvents[index].user!.uuid ==
                                                userId;
                                        context.pushNamed(
                                          'event_details',
                                          extra: {
                                            'eventId': upcomingEvents[index].id,
                                            'isOwnEvent': isOwnEvent,
                                          },
                                        );
                                      },
                                      child: UpcomingEventListTemplate(
                                        eventName: upcomingEvents[index].name,
                                        eventImageString:
                                            upcomingEvents[index].image,
                                        eventDay: getDayName(
                                            upcomingEvents[index].date),
                                        eventDate: convertDateDotFormat(
                                          DateTime.parse(
                                              upcomingEvents[index].date),
                                        ),
                                        eventId: upcomingEvents[index].id,
                                        eventLocation:
                                            upcomingEvents[index].venue,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              bigHeight(),
                            ],
                          );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        'No upcoming events at the moment',
                        style: inter14Black400(context),
                      ),
                    );
                  }
                }),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: SizedBox(
                    width: width,
                    height: 100,
                    child: BlocBuilder<NotificationsBloc, NotificationsState>(
                      builder: (context, state){
                        
                      if (state is NotificationsLoadingState){
                        return SizedBox();
                      }

                      else if (state is NotificationsLoadedState){

                        flashNotifications = state.notifications;
                        
                        return ListView.builder(
                      itemCount: flashNotifications.length > 3 ? 3 : flashNotifications.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return FlashNotificationsTemplate(noificationTitle: flashNotifications[index].headline, noificationBody: flashNotifications[index].description);
                      },
                    );
                    }

                      return SizedBox();

                    },)
                  ),
                ),
                normalHeight(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    language.explore,
                    style: inter16Black600(context),
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
                                      titleText: language.all,
                                      titleTextColor:
                                          Theme.of(context).colorScheme.surface,
                                      containerColor: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      containerBorderColor: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      textSize: 12.sp,
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(right: 0),
                                child: GestureDetector(
                                  onTap: () {
                                    context.push(
                                      '/category',
                                      extra: {
                                        'categoryId':
                                            state.categories[index - 1].id,
                                        'categoryName':
                                            state.categories[index - 1].name,
                                      },
                                    );
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
                      return emptyListWithShimmer();
                    } else if (state is PublicEventLoading) {
                      return Center(child: CupertinoActivityIndicator());
                    } else if (state is PublicEventLoaded) {
                      publicEvents = state.events.reversed.toList();
                      if (publicEvents.isEmpty) {
                        return emptyListView();
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: publicEvents.length,
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
                                bool isOwnEvent =
                                    publicEvents[index].user!.uuid == userId;
                                context.pushNamed(
                                  'event_details',
                                  extra: {
                                    'eventId': publicEvents[index].id,
                                    'isOwnEvent': isOwnEvent,
                                  },
                                );
                              },
                              child: EventListTemplate(
                                eventOwner: publicEvents[index].username,
                                eventName: publicEvents[index].name,
                                eventLocation:
                                    publicEvents[index].venue.split(',').first,
                                eventDay: getDayName(publicEvents[index].date),
                                eventDate: convertDateDotFormat(
                                    DateTime.parse(publicEvents[index].date)),
                                eventImageString: publicEvents[index].image!,
                                eventId: publicEvents[index].id,
                                hasLikedEvent:
                                    publicEvents[index].hasLikedEvent,
                                eventOwnerAvatar:
                                    publicEvents[index].user!.avatar,
                                inviteStatus: getInviteStatus(
                                    publicEvents[index], userId),
                                showStatusBadge: false,
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
