import 'package:flutter/material.dart';

import '../../../components/app_bar_template.dart';
import '../../../constants/color_constants.dart';

class GuestListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBarTemplate(pageTitle: "Guest List"),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container();
          },
        ),
      ),
    );
  }

  guestListLayout(String imageUrl, String userName, String eventStatus) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Text(
            userName,
            style: TextStyle(
              fontSize: 16,
              color: ColorConstants.black,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            width: 60,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ColorConstants.primary,
            ),
            child: Text(
              "ACCEPTED",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: "Poppins",
                color: ColorConstants.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
