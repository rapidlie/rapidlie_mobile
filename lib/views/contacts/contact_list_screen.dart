import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapidlie/components/app_bar_template.dart';
import 'package:rapidlie/components/button_template.dart';

import '../../constants/color_constants.dart';

class ContactListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBarTemplate(pageTitle: "Contacts"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 180,
                ),
                Text(
                  'Invite your friends',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.black,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'None of your contacts are using RAPIDLIE. Click on the button below to invite them.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: ColorConstants.charcoalBlack,
                    height: 1.2,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ButtonTemplate(
                  buttonName: "invite friends",
                  buttonColor: ColorConstants.primary,
                  buttonWidth: Get.width,
                  buttonHeight: 50,
                  buttonAction: () {},
                  fontColor: Colors.white,
                  textSize: 10,
                  buttonBorderRadius: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
