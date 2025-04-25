import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/settings/presentation/widgets/settings_container_layout.dart';
import 'package:rapidlie/features/user/models/user_model.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

import '../widgets/settings_item_layout.dart';

class ProfileSettingsScreen extends StatelessWidget {
  late var language;
  UserModel userModel = Get.arguments;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    language = AppLocalizations.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: "Profile settings",
          isSubPage: true,
        ),
      ),
      backgroundColor: Colors.white,
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
                      ),
                      child: ClipOval(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/placeholder.png',
                          image: userModel.avatar,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/images/placeholder.png'),
                          imageCacheHeight: 100,
                          imageCacheWidth: 100,
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
                          userModel.name,
                          style: inter15black500(),
                        ),
                        Text(
                          userModel.phone,
                          style: inter10CharcoalBlack400(),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SettingsContainerLayout(
                  childWidget: Column(
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
                        onCLickFunction: () {
                          Navigator.pushNamed(context, "/delete-account");
                        },
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
