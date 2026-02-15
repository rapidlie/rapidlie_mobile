import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/settings/presentation/widgets/custom_divider.dart';
import 'package:rapidlie/features/settings/presentation/widgets/settings_container_layout.dart';
import 'package:rapidlie/features/user/models/user_model.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

import '../widgets/settings_item_layout.dart';

class ProfileSettingsScreen extends StatelessWidget {
  late var language;
  final UserModel userProfile;

  ProfileSettingsScreen({Key? key, required this.userProfile})
      : super(key: key);

  static ProfileSettingsScreen fromState(GoRouterState state) {
    final data = state.extra as Map<String, dynamic>;
    return ProfileSettingsScreen(
      userProfile: data['userProfile'] as UserModel,
    );
  }

  //UserModel userModel = Get.arguments;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    language = AppLocalizations.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: language.profileSettings,
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
                      ),
                      child: ClipOval(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/placeholder.png',
                          image: userProfile.avatar,
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
                          userProfile.name,
                          style: inter15black500(context),
                        ),
                        Text(
                          userProfile.phone ?? "",
                          style: inter10Black400(context),
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
                        title: language.changePassword,
                        iconColor: Theme.of(context).colorScheme.primary,
                        onCLickFunction: () {
                          context.push("/change_password");
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: customDivider(context),
                      ),
                      SettingsItemLayout(
                        icon: Icons.delete,
                        title: language.deleteAccount,
                        iconColor: Colors.red,
                        onCLickFunction: () {
                          context.push("/delete_account");
                        },
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
