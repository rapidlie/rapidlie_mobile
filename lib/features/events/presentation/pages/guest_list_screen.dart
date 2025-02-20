import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/events/models/event_model.dart';

import '../../../../core/constants/custom_colors.dart';

class GuestListScreen extends StatefulWidget {
  final List<Invitation> guests = Get.arguments as List<Invitation>;

  @override
  State<GuestListScreen> createState() => _GuestListScreenState();
}

class _GuestListScreenState extends State<GuestListScreen> {
  @override
  Widget build(BuildContext context) {
    //debugPrint(Get.arguments.runtimeType.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: SafeArea(
          child: AppBarTemplate(
            pageTitle: "Guest List",
            isSubPage: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Container(
            height: Get.height,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.guests.length,
              itemBuilder: (context, index) {
                print(widget.guests[index].status);
                return guestListLayout(
                  userName: widget.guests[index].user.name,
                  eventStatus: widget.guests[index].status,
                  imageUrl: widget.guests[index].user.avatar,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  guestListLayout(
      {required String? imageUrl,
      String? userName,
      required String eventStatus}) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/placeholder.png',
                        image: imageUrl ?? "",
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/images/placeholder.png'),
                        imageCacheHeight: 100,
                        imageCacheWidth: 100,
                      ),
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
                  userName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: CustomColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: eventStatus == "accepted"
                  ? CustomColors.acceptedContainerColor
                  : eventStatus == "declined"
                      ? CustomColors.rejectedContainerColor
                      : CustomColors.rejectedContainerColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                eventStatus == "accepted"
                    ? "ACCEPTED"
                    : eventStatus == "declined"
                        ? "DECLINED"
                        : "PENDING",
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: eventStatus == "accepted"
                      ? CustomColors.acceptedTextColor
                      : eventStatus == "declined"
                          ? CustomColors.rejectedTextColor
                          : CustomColors.rejectedTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
