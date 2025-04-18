// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_stack/image_stack.dart';
import 'package:rapidlie/core/utils/date_formatters.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
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

class EventDetailsScreeen extends StatefulWidget {
  final bool isOwnEvent;
  var language;
  //final bool? initialEventLiked;
  EventDataModel eventDetails = Get.arguments;

  EventDetailsScreeen({
    Key? key,
    required this.isOwnEvent,
    this.language,
  }) : super(key: key);

  @override
  State<EventDetailsScreeen> createState() => _EventDetailsScreeenState();
}

class _EventDetailsScreeenState extends State<EventDetailsScreeen> {
  late bool isLiked = widget.eventDetails.hasLikedEvent;
  bool inviteAccepted = false;
  bool inviteDeclined = false;

  late String userId;
  late String inviteStatus;

  late GoogleMapController mapController;

  late LatLng _initialPosition; // Coordinates for initial map location

  /* void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  } */

  @override
  void initState() {
    super.initState();
    extractLatLngFromString(widget.eventDetails.mapLocation);
    getUserID();
    getInviteStatus();
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

  void getInviteStatus() {
    inviteStatus = widget.isOwnEvent
        ? "accepted"
        : widget.eventDetails.eventType == "public"
            ? "pending"
            : widget.eventDetails.invitations
                .firstWhere(
                  (invitation) => invitation.user.uuid == userId,
                )
                .status;
  }

  @override
  Widget build(BuildContext context) {
    widget.language = AppLocalizations.of(context);

    List<String> userImages = [
      for (var invite in widget.eventDetails.invitations)
        invite.user.avatar ?? ""
    ];

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
                    onTap: () => Get.back(),
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
                                  widget.eventDetails.name,
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.0,
                                  ),
                                ),
                                HeaderTextTemplate(
                                  titleText: widget.eventDetails.category.name,
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
                                  toggleLike(widget.eventDetails.id);
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
                    widget.eventDetails.image!,
                    //width: double.maxFinite,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: Get.height,
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
                                      convertDateDotFormat(DateTime.parse(
                                          widget.eventDetails.date)),
                                      style: GoogleFonts.inter(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      getDayName(widget.eventDetails.date),
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
                                          widget.eventDetails.startTime,
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
                                      widget.eventDetails.venue
                                          .split(",")
                                          .first,
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
                          widget.eventDetails.description,
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
                        widget.eventDetails.eventType == "public" &&
                                widget.isOwnEvent
                            ? Text(
                                widget.language.invites,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : widget.eventDetails.eventType == "public"
                                ? SizedBox.shrink()
                                : Text(
                                    widget.language.invites,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        extraSmallHeight(),
                        widget.eventDetails.eventType == "public" &&
                                widget.isOwnEvent
                            ? GestureDetector(
                                onTap: () {
                                  Get.to(() => GuestListScreen(),
                                      arguments:
                                          widget.eventDetails.invitations);
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
                            : widget.eventDetails.eventType == "public"
                                ? SizedBox.shrink()
                                : GestureDetector(
                                    onTap: () {
                                      Get.to(() => GuestListScreen(),
                                          arguments:
                                              widget.eventDetails.invitations);
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
                                inviteStatus = inviteStatus == "accepted"
                                    ? "declined"
                                    : "accepted";
                              }
                              return ButtonTemplate(
                                buttonName: inviteStatus == "accepted"
                                    ? "Decline"
                                    : "Accept",
                                buttonWidth: width,
                                loading: acceptButtonLoading,
                                buttonAction: () {
                                  context
                                      .read<ConsentBloc>()
                                      .add(GiveConsentEvent(
                                        status: inviteStatus == "accepted"
                                            ? 'declined'
                                            : 'accepted',
                                        eventId: widget.eventDetails.id,
                                      ));
                                },
                                textColor: Colors.white,
                                buttonColor: inviteStatus == "accepted"
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
}
