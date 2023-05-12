import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapidlie/constants/color_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsScreeen extends StatelessWidget {
  void openMap() async {
    // Replace the address with your own value
    String address = "1600 Amphitheatre Parkway, Mountain View, CA";

    // Encode the address for use in a URL
    String encodedAddress = Uri.encodeComponent(address);

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Container(
                color: Colors.white,
                width: double.maxFinite,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, bottom: 20, top: 20),
                  child: Text(
                    "Eugene weds Jedidah",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ),
            centerTitle: false,
            backgroundColor: Colors.white,
            expandedHeight: 450,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "assets/images/dansoman.jpeg",
                width: double.maxFinite,
                fit: BoxFit.cover,
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
                    Text(
                      'About',
                      style: TextStyle(
                        color: ColorConstants.primary,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                      ),
                    ),
                    Text(
                      'This is a wedding ceremony between the families of Eugene Ofori Asiedu and Jedidah Narko Odechie Amanor. These two have dated for the past 4 years ad today, the meet to make things official',
                      style: TextStyle(
                        color: ColorConstants.black,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Data',
                      style: TextStyle(
                        color: ColorConstants.primary,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                      ),
                    ),
                    Text(
                      'Saturday, 28 April',
                      style: TextStyle(
                        color: ColorConstants.black,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Time',
                      style: TextStyle(
                        color: ColorConstants.primary,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '11:30am',
                          style: TextStyle(
                            color: ColorConstants.black,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          ' - ',
                          style: TextStyle(
                            color: ColorConstants.black,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '3:30pm',
                          style: TextStyle(
                            color: ColorConstants.black,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Venue',
                      style: TextStyle(
                        color: ColorConstants.primary,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                      ),
                    ),
                    Text(
                      'Church of Pentecost, Dansoman',
                      style: TextStyle(
                        color: ColorConstants.black,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Directions',
                      style: TextStyle(
                        color: ColorConstants.primary,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: openMap,
                      child: Text(
                        'Click here for directions to event',
                        style: TextStyle(
                          color: ColorConstants.secondary,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Invites',
                      style: TextStyle(
                        color: ColorConstants.primary,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
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
