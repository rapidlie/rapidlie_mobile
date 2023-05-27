import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/app_bar_template.dart';
import '../../../constants/color_constants.dart';

class GuestListScreen extends StatelessWidget {
  List profileImg = [
    "assets/images/usr1.png",
    "assets/images/usr2.png",
    "assets/images/usr3.png",
    "assets/images/usr4.png",
    "assets/images/usr1.png",
    "assets/images/usr2.png",
    "assets/images/usr3.png",
    "assets/images/usr4.png",
    "assets/images/usr1.png",
    "assets/images/usr2.png",
  ];
  List userNames = [
    "Eugene Ofori Asiedu",
    "Jedidah Narko Odechie Amanor",
    "Patience Asiedu",
    "Kofi Asiedu",
    "Abigail Asiedu",
    "Andrews Yawson",
    "Ronnald Kofi Yanney",
    "Seyram Kofi Mantey",
    "Quincy Hagan",
    "Alberta Hagan",
  ];
  List eventStatus = [
    "ACCEPTED",
    "PENDING",
    "ACCEPTED",
    "REJECTED",
    "REJECTED",
    "PENDING",
    "ACCEPTED",
    "REJECTED",
    "REJECTED",
    "ACCEPTED",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBarTemplate(pageTitle: "Guest List"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Container(
            height: Get.height,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                return guestListLayout(
                  profileImg[index],
                  userNames[index],
                  eventStatus[index],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  guestListLayout(String imageUrl, String userName, String eventStatus) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConstants.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: CircleAvatar(
                      foregroundImage: AssetImage(imageUrl),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 200,
                child: Text(
                  userName,
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorConstants.black,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ColorConstants.acceptedContainerColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                eventStatus,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Poppins",
                  color: ColorConstants.acceptedTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
