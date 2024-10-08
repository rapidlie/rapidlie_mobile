// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rapidlie/core/utils/date_formatters.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:rapidlie/core/constants/color_constants.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';
import 'package:rapidlie/core/widgets/header_title_template.dart';
import 'package:rapidlie/features/events/presentation/pages/guest_list_screen.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class EventDetailsScreeen extends StatelessWidget {
  final bool isOwnEvent;
  var language;

  EventDetailsScreeen({
    Key? key,
    required this.isOwnEvent,
    this.language,
  }) : super(key: key);

  void openMap() async {
    // Replace the address with your own value
    //String address = "1600 Amphitheatre Parkway, Mountain View, CA";

    // Encode the address for use in a URL
    //String encodedAddress = Uri.encodeComponent(address);

    // Construct the Google Maps URL with the encoded address
    String mapsUrl =
        "https://www.google.com/maps/place/Kosmos+Innovation+Center+-+Incubation+Hub/@5.6179446,-0.1903505,17z/data=!3m1!4b1!4m6!3m5!1s0xfdf9bc563e448cf:0x617eb06c3af71e8d!8m2!3d5.6179446!4d-0.1877756!16s%2Fg%2F11h5h3x86v";

    // Launch the URL
    if (await canLaunchUrl(Uri.parse(mapsUrl))) {
      await launchUrl(Uri.parse(mapsUrl));
    } else {
      throw "Could not launch $mapsUrl";
    }
  }

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);
    EventDataModel eventDetails = Get.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
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
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eventDetails.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
                            ),
                          ),
                          HeaderTextTemplate(
                            titleText: eventDetails.category.name,
                            titleTextColor: Colors.black,
                            containerColor: Color.fromARGB(133, 218, 218, 218),
                            textSize: 10,
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          isOwnEvent
                              ? Icon(
                                  Icons.edit_outlined,
                                  color: Colors.black,
                                )
                              : SizedBox(),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: SvgPicture.asset("assets/icons/chat.svg"),
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
            expandedHeight: 450,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                eventDetails.image!,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderTextTemplate(
                      titleText: language.description,
                      titleTextColor: ColorConstants.colorFromHex("#8E44AD"),
                      containerColor: ColorConstants.colorFromHex("#EFDAF7"),
                      textSize: 11.0,
                      iconWidget: Icon(
                        Icons.info,
                        color: ColorConstants.colorFromHex("#8E44AD"),
                        size: 16,
                      ),
                    ),
                    extraSmallHeight(),
                    Text(
                      eventDetails.description,
                      style: poppins13black400(),
                    ),
                    normalHeight(),
                    HeaderTextTemplate(
                      titleText: language.date,
                      titleTextColor: ColorConstants.colorFromHex("#E57E25"),
                      containerColor: ColorConstants.colorFromHex("#FFF2E7"),
                      textSize: 11.0,
                      iconWidget: Icon(
                        Icons.date_range,
                        color: ColorConstants.colorFromHex("#E57E25"),
                        size: 16,
                      ),
                    ),
                    extraSmallHeight(),
                    Row(
                      children: [
                        Text(
                          getDayName(eventDetails.date),
                          style: TextStyle(
                            fontSize: 11.0,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            height: 10,
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          convertDateDotFormat(
                              DateTime.parse(eventDetails.date)),
                          style: TextStyle(
                            fontSize: 11.0,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    normalHeight(),
                    HeaderTextTemplate(
                      titleText: language.time,
                      titleTextColor: ColorConstants.colorFromHex("#0E1339"),
                      containerColor: ColorConstants.colorFromHex("#DEE1EA"),
                      textSize: 11.0,
                      iconWidget: Icon(
                        Icons.timelapse,
                        color: ColorConstants.colorFromHex("#0E1339"),
                        size: 16,
                      ),
                    ),
                    extraSmallHeight(),
                    Row(
                      children: [
                        Text(
                          eventDetails.startTime,
                          style: poppins13black400(),
                        ),
                        Text(
                          ' - ',
                          style: poppins13black400(),
                        ),
                        Text(
                          eventDetails.endTime,
                          style: poppins13black400(),
                        ),
                      ],
                    ),
                    normalHeight(),
                    HeaderTextTemplate(
                      titleText: language.venue,
                      titleTextColor: ColorConstants.colorFromHex("#E74C3C"),
                      containerColor: ColorConstants.colorFromHex("#FFF2F0"),
                      textSize: 11.0,
                      iconWidget: Icon(
                        Icons.place,
                        color: ColorConstants.colorFromHex("#E74C3C"),
                        size: 16,
                      ),
                    ),
                    extraSmallHeight(),
                    Text(
                      eventDetails.mapLocation,
                      style: poppins13black400(),
                    ),
                    normalHeight(),
                    HeaderTextTemplate(
                      titleText: language.directions,
                      titleTextColor: ColorConstants.colorFromHex("#0064A7"),
                      containerColor: ColorConstants.colorFromHex("#E6F7FD"),
                      textSize: 11.0,
                      iconWidget: Icon(
                        Icons.directions,
                        color: ColorConstants.colorFromHex("#0064A7"),
                        size: 16,
                      ),
                    ),
                    extraSmallHeight(),
                    GestureDetector(
                      onTap: openMap,
                      child: Text(
                        'Click here for directions to event',
                        style: poppins13black400(),
                      ),
                    ),
                    normalHeight(),
                    HeaderTextTemplate(
                      titleText: language.invites,
                      titleTextColor: ColorConstants.colorFromHex("#A58D0E"),
                      containerColor:
                          ColorConstants.colorFromHex("#F9F2B2").withAlpha(150),
                      textSize: 11.0,
                      iconWidget: Icon(
                        Icons.insert_invitation,
                        color: ColorConstants.colorFromHex("#A58D0E"),
                        size: 16,
                      ),
                    ),
                    extraSmallHeight(),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => GuestListScreen());
                      },
                      child: Container(
                        width: double.maxFinite,
                        child: Stack(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorConstants.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: CircleAvatar(
                                    foregroundImage:
                                        AssetImage("assets/images/usr1.png"),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 260,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorConstants.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: CircleAvatar(
                                      foregroundImage:
                                          AssetImage("assets/images/usr2.png"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 205,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorConstants.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: CircleAvatar(
                                      foregroundImage:
                                          AssetImage("assets/images/usr4.png"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 50,
                              height: 40,
                              child: Center(
                                child: Text(
                                  '32 guests',
                                  style: poppins13black400(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
