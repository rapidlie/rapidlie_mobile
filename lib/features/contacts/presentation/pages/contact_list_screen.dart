import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/contacts/presentation/widgets/contact_list_item.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactListScreen extends StatelessWidget {
  List contacts = [
    "Eugene Asiedu",
    "Daniel Rodriguez",
    "Jedidah Amanor",
    "Sylivia Nataka",
    "Yaw Asiedu"
  ];

  void inviteFriend() async {
    String message = "Hey, check out this cool event app!";
    String encodedMessage = Uri.encodeComponent(message);
    String smsUrl = "sms:?body=$encodedMessage";

    if (await canLaunchUrl(Uri.parse(smsUrl))) {
      await launchUrl(Uri.parse(smsUrl));
    } else {
      throw "Could not launch $smsUrl";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: SafeArea(
          child: AppBarTemplate(
            pageTitle: "Contacts",
            isSubPage: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            height: height,
            width: width,
            child: ListView.builder(
              itemCount: contacts.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ContactListItem(
                  contactName: contacts[index],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
