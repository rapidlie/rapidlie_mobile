import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_stack/image_stack.dart';
import 'package:rapidlie/core/utils/date_formatters.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';
import 'package:rapidlie/features/events/blocs/give_consent_bloc/consent_bloc.dart';
import 'package:rapidlie/features/events/blocs/like_bloc/like_event_bloc.dart';
import 'package:rapidlie/features/events/blocs/like_bloc/like_event_event.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/widgets/header_title_template.dart';
import 'package:rapidlie/features/events/presentation/pages/guest_list_screen.dart';
import 'package:rapidlie/features/events/presentation/pages/map_direction_launcher.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class EventDetailsScreen extends StatefulWidget {
  final bool isOwnEvent;
  String? inviteStatus;
  var language;

  EventDataModel event;

  EventDetailsScreen({
    Key? key,
    required this.isOwnEvent,
    this.language,
    this.inviteStatus,
    required this.event,
  }) : super(key: key);

  static EventDetailsScreen fromState(GoRouterState state) {
    final data = state.extra as Map<String, dynamic>;
    return EventDetailsScreen(
      event: data['event'] as EventDataModel,
      inviteStatus: data['inviteStatus'] as String,
      isOwnEvent: data['isOwnEvent'] as bool,
    );
  }

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late bool isLiked = widget.event.hasLikedEvent;
  bool inviteAccepted = false;
  bool inviteDeclined = false;

  late String userId;

  late GoogleMapController mapController;

  late LatLng _initialPosition; // Coordinates for initial map location

  /* void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  } */

  @override
  void initState() {
    super.initState();
    extractLatLngFromString(widget.event.mapLocation);
    getUserID();
    //getInviteStatus();
  }

  void getUserID() async {
    userId = UserPreferences().getUserId().toString();
  }

  void toggleLike(eventId) async {
    setState(() {
      isLiked = !isLiked;
    });

    try {
      context.read<LikeEventBloc>().add(LikeToggled(eventId!));
    } catch (error) {
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  void extractLatLngFromString(String latLngString) {
    final regex = RegExp(r"LatLng\(([^,]+), ([^)]+)\)");
    final match = regex.firstMatch(latLngString);

    if (match != null) {
      double latitude = double.parse(match.group(1)!);
      double longitude = double.parse(match.group(2)!);

      _initialPosition = LatLng(latitude, longitude);
    } else {
      print("Invalid format");
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.language = AppLocalizations.of(context);

    List<String> userImages = [
      for (var invite in widget.event.invitations) invite.user.avatar ?? ""
    ];
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                leading: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CustomColors.lightGray,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: Container(
                    color: Colors.white,
                    width: double.maxFinite,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.event.name,
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.0,
                                  ),
                                ),
                                HeaderTextTemplate(
                                  titleText: widget.event.category.name,
                                  titleTextColor: Colors.black,
                                  containerColor:
                                      Color.fromARGB(133, 218, 218, 218),
                                  textSize: 8,
                                  verticalPadding: 5,
                                  horizontalPadding: 10,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  toggleLike(widget.event.id);
                                },
                                child: Icon(
                                  isLiked
                                      ? Icons.favorite_sharp
                                      : Icons.favorite_border_sharp,
                                  size: 25,
                                  color: isLiked ? Colors.red : Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                child: Icon(
                                  Icons.bookmark_border_sharp,
                                  size: 25,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                centerTitle: false,
                backgroundColor: Colors.white,
                expandedHeight: 400,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    widget.event.image!,
                    //width: double.maxFinite,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: height,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(borderRadius),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset:
                                    Offset(0, 5), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.language.date,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    extraSmallHeight(),
                                    Text(
                                      convertDateDotFormat(
                                          DateTime.parse(widget.event.date)),
                                      style: GoogleFonts.inter(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      getDayName(widget.event.date),
                                      style: GoogleFonts.inter(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 20,
                                  width: 1,
                                  color: CustomColors.lightGray,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.language.time,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    extraSmallHeight(),
                                    Row(
                                      children: [
                                        Text(
                                          widget.event.startTime,
                                          style: GoogleFonts.inter(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 20,
                                  width: 1,
                                  color: CustomColors.lightGray,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.language.venue,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    extraSmallHeight(),
                                    Text(
                                      widget.event.venue.split(",").first,
                                      style: GoogleFonts.inter(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        smallHeight(),
                        Text(
                          widget.language.description,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.event.description,
                          style: GoogleFonts.inter(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        normalHeight(),
                        Text(
                          widget.language.directions,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        MapDirectionLauncher(
                          targetLocation: _initialPosition,
                        ),
                        normalHeight(),
                        widget.event.eventType == "public" && widget.isOwnEvent
                            ? Text(
                                widget.language.invites,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : widget.event.eventType == "public"
                                ? SizedBox.shrink()
                                : Text(
                                    widget.language.invites,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        extraSmallHeight(),
                        widget.event.eventType == "public" && widget.isOwnEvent
                            ? GestureDetector(
                                onTap: () {
                                  Get.to(() => GuestListScreen(),
                                      arguments: widget.event.invitations);
                                },
                                child: ImageStack(
                                  imageList: userImages,
                                  imageRadius: 50,
                                  showTotalCount: false,
                                  imageBorderWidth: 2,
                                  imageCount: userImages.length,
                                  imageBorderColor: Colors.white,
                                  backgroundColor: Colors.grey,
                                  extraCountBorderColor: Colors.grey,
                                  totalCount: userImages.length,
                                ),
                              )
                            : widget.event.eventType == "public"
                                ? SizedBox.shrink()
                                : GestureDetector(
                                    onTap: () {
                                      Get.to(() => GuestListScreen(),
                                          arguments: widget.event.invitations);
                                    },
                                    child: ImageStack(
                                      imageList: userImages,
                                      imageRadius: 50,
                                      showTotalCount: false,
                                      imageBorderWidth: 2,
                                      imageCount: userImages.length,
                                      imageBorderColor: Colors.white,
                                      backgroundColor: Colors.grey,
                                      extraCountBorderColor: Colors.grey,
                                      totalCount: userImages.length,
                                    ),
                                  ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Positioned(
            bottom: 20.0,
            left: 20.0,
            right: 20.0,
            child: widget.isOwnEvent
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: BlocBuilder<ConsentBloc, ConsentState>(
                            builder: (context, state) {
                              bool acceptButtonLoading =
                                  state is ConsentLoadingState;

                              if (state is ConsentLoadedState) {
                                context
                                    .read<InvitedEventBloc>()
                                    .add(GetInvitedEvents());
                                context
                                    .read<UpcomingEventBloc>()
                                    .add(GetUpcomingEvents());
                                context
                                    .read<UpcomingEventBloc>()
                                    .invalidateCache();
                                Future.delayed(
                                  Duration(seconds: 2),
                                  () {
                                    BlocProvider.of<ConsentBloc>(context)
                                        .add(ResetGiveConsentEvent());
                                    switchInviteStatusValue();
                                  },
                                );
                              }
                              return ButtonTemplate(
                                buttonName: widget.inviteStatus == "accepted"
                                    ? "Decline"
                                    : "Accept",
                                buttonWidth: width,
                                loading: acceptButtonLoading,
                                buttonAction: () {
                                  context
                                      .read<ConsentBloc>()
                                      .add(GiveConsentEvent(
                                        status:
                                            widget.inviteStatus == "accepted"
                                                ? 'declined'
                                                : 'accepted',
                                        eventId: widget.event.id,
                                      ));
                                },
                                textColor: Colors.white,
                                buttonColor: widget.inviteStatus == "accepted"
                                    ? Colors.red
                                    : Colors.black,
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void switchInviteStatusValue() {
    setState(() {
      widget.inviteStatus =
          widget.inviteStatus == "accepted" ? "declined" : "accepted";
    });
  }
}
