import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapidlie/views/contacts/contact_details.dart';

import '../../../components/app_bar_template.dart';
import '../../../constants/color_constants.dart';

class GuestListScreen extends StatelessWidget {
  List<ContactDetails> invitedGuests = [
    ContactDetails(
      name: "Eugene Ofori Asiedu",
      image: "assets/images/usr1.png",
      status: Status.accepted,
    ),
    ContactDetails(
      name: "Jedidah Narko Odechie Amanor",
      image: "assets/images/usr2.png",
      status: Status.pending,
    ),
    ContactDetails(
      name: "Patience Asiedu",
      image: "assets/images/usr3.png",
      status: Status.accepted,
    ),
    ContactDetails(
      name: "Kofi Asiedu",
      image: "assets/images/usr4.png",
      status: Status.rejected,
    ),
    ContactDetails(
      name: "Abigail Akua Agyeiwaa Asiedu",
      image: "assets/images/usr1.png",
      status: Status.pending,
    ),
    ContactDetails(
      name: "Ronald Kofi Yanney",
      image: "assets/images/usr2.png",
      status: Status.accepted,
    ),
    ContactDetails(
      name: "Seyram Kofi Mantey",
      image: "assets/images/usr3.png",
      status: Status.rejected,
    ),
    ContactDetails(
      name: "Quincy Hagan",
      image: "assets/images/usr4.png",
      status: Status.rejected,
    ),
    ContactDetails(
      name: "Alberta Hagan",
      image: "assets/images/usr1.png",
      status: Status.accepted,
    ),
    ContactDetails(
      name: "Andrews Yawson",
      image: "assets/images/usr2.png",
      status: Status.accepted,
    ),
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
                  invitedGuests[index].image!,
                  invitedGuests[index].name,
                  invitedGuests[index].status!,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  guestListLayout(String imageUrl, String userName, Status eventStatus) {
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
              color: eventStatus == Status.accepted
                  ? ColorConstants.acceptedContainerColor
                  : eventStatus == Status.rejected
                      ? ColorConstants.rejectedContainerColor
                      : ColorConstants.pendingContainerColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                eventStatus == Status.accepted
                    ? "ACCEPTED"
                    : eventStatus == Status.rejected
                        ? "REJECTED"
                        : "PENDING",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Poppins",
                  color: eventStatus == Status.accepted
                      ? ColorConstants.acceptedTextColor
                      : eventStatus == Status.rejected
                          ? ColorConstants.rejectedTextColor
                          : ColorConstants.pendingTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
