import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/gravata_to_image.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

import '../widgets/settings_item_layout.dart';

class ProfileSettingsScreen extends StatelessWidget {
  late var language;
  String email = "yawsonandrews@gmail.com";

  @override
  Widget build(BuildContext context) {
    String imageUrl = getGitHubIdenticonUrl("asiedu", size: 200);
    language = AppLocalizations.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: "Profile settings",
          isSubPage: true,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Container(
          height: height,
          width: width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade600,
                      ),
                      child: ClipOval(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/placeholder.png',
                          image: imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Eugene Ofori Asiedu",
                          style: poppins14black500(),
                        ),
                        Text(
                          "+233 50 613 8718",
                          style: poppins10black400(),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    children: [],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SettingsItemLayout(
                        icon: Icons.lock,
                        title: "Change password",
                        iconColor: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Container(
                          height: 1,
                          color: const Color.fromARGB(255, 240, 239, 239),
                        ),
                      ),
                      SettingsItemLayout(
                        icon: Icons.delete,
                        title: "Delete account",
                        iconColor: Colors.red,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Container(
                          height: 1,
                          color: const Color.fromARGB(255, 240, 239, 239),
                        ),
                      ),
                      SettingsItemLayout(
                        icon: Icons.report,
                        title: "Report problem",
                        iconColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
