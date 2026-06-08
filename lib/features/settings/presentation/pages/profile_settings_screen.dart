import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        preferredSize: const Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: language.profileSettings,
          isSubPage: true,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: SizedBox(
          height: height,
          width: width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                // Profile header with gradient
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.6),
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/placeholder.png',
                            image: userProfile.avatar,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                Image.asset('assets/images/placeholder.png'),
                            imageCacheHeight: 90,
                            imageCacheWidth: 90,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userProfile.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        userProfile.phone ?? "",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SettingsContainerLayout(
                  childWidget: Column(
                    children: [
                      SettingsItemLayout(
                        icon: Icons.confirmation_number_outlined,
                        title: 'My Tickets',
                        iconColor: Theme.of(context).colorScheme.primary,
                        onCLickFunction: () {
                          context.pushNamed('tickets');
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: customDivider(context),
                      ),
                      SettingsItemLayout(
                        icon: Icons.people_outline,
                        title: 'Find Friends',
                        iconColor: Theme.of(context).colorScheme.primary,
                        onCLickFunction: () {
                          context.pushNamed('contacts');
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: customDivider(context),
                      ),
                      SettingsItemLayout(
                        icon: Icons.volunteer_activism_outlined,
                        title: 'My Contributions',
                        iconColor: Theme.of(context).colorScheme.primary,
                        onCLickFunction: () {
                          context.pushNamed('my_contributions');
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: customDivider(context),
                      ),
                      SettingsItemLayout(
                        icon: Icons.mail_outline,
                        title: 'Pending Invitations',
                        iconColor: Theme.of(context).colorScheme.primary,
                        onCLickFunction: () {
                          context.pushNamed('pending_invitations');
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: customDivider(context),
                      ),
                      SettingsItemLayout(
                        icon: Icons.tune_outlined,
                        title: 'App Settings',
                        iconColor: Theme.of(context).colorScheme.primary,
                        onCLickFunction: () {
                          context.pushNamed('app_settings');
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: customDivider(context),
                      ),
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
