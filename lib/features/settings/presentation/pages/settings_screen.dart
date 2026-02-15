import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/logout/bloc/logout_bloc.dart';
import 'package:rapidlie/features/settings/blocs/profile_bloc/profile_bloc.dart';
import 'package:rapidlie/features/settings/presentation/widgets/custom_divider.dart';
import 'package:rapidlie/features/settings/presentation/widgets/settings_container_layout.dart';
import 'package:rapidlie/features/settings/providers/change_language_provider.dart';
import 'package:rapidlie/features/settings/presentation/widgets/country_settings_layout.dart';
import 'package:rapidlie/features/settings/presentation/widgets/language_settings_layout.dart';
import 'package:rapidlie/features/settings/presentation/widgets/settings_item_layout.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '';
  late var language;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetProfileEvent());
    _initAppVersion();
  }

  Future<void> _initAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    language = AppLocalizations.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBarTemplate(
            pageTitle: language.settings,
            isSubPage: false,
          ),
        ),
        body: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Container(
            height: height,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfileLoadingState) {
                      } else if (state is ProfileLoadedState) {
                        return GestureDetector(
                          onTap: () {
                            context.push('/profile',
                                extra: {'userProfile': state.userProfile});
                          },
                          child: SettingsContainerLayout(
                            childWidget: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: ClipOval(
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                'assets/images/placeholder.png',
                                            image: state.userProfile.avatar,
                                            fit: BoxFit.cover,
                                            imageErrorBuilder: (context, error,
                                                    stackTrace) =>
                                                Image.asset(
                                                    'assets/images/placeholder.png'),
                                            imageCacheHeight: 100,
                                            imageCacheWidth: 100,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.userProfile.name,
                                            style: inter15black500(context),
                                          ),
                                          Text(
                                            state.userProfile.phone ?? "",
                                            style: inter10Black400(context),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey.shade300,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          context
                              .push('/profile', extra: {'userProfile': null});
                        },
                        child: SettingsContainerLayout(
                          childWidget: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
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
                                        color: Colors.grey.shade600,
                                      ),
                                      child: ClipOval(
                                        child: FadeInImage(
                                          image: AssetImage(
                                              'assets/images/placeholder.png'),
                                          fit: BoxFit.cover,
                                          placeholder: AssetImage(
                                              'assets/images/placeholder.png'),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          UserPreferences().getUserName(),
                                          style: inter15black500(context),
                                        ),
                                        Text(
                                          UserPreferences().getTelephone(),
                                          style: inter10Black400(context),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey.shade300,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  normalHeight(),
                  Text(
                    language.general,
                    style: inter14black500(context),
                  ),
                  extraSmallHeight(),
                  SettingsContainerLayout(
                    childWidget: Consumer<ChangeLanguageProvider>(
                      builder: (context, provider, child) {
                        return Column(
                          children: [
                            SettingsItemLayout(
                              icon: Icons.language,
                              title: language.language,
                              value: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  provider.applicationLocale == Locale("en")
                                      ? language.english
                                      : provider.applicationLocale ==
                                              Locale("de")
                                          ? language.german
                                          : provider.applicationLocale ==
                                                  Locale("fr")
                                              ? language.french
                                              : language.english,
                                  style: inter13black400(context),
                                ),
                              ),
                              iconColor: Colors.blue,
                              onCLickFunction: () =>
                                  showModal(language.language, context, width),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: customDivider(context),
                            ),
                            SettingsItemLayout(
                              icon: Icons.flag,
                              title: language.country,
                              value: Container(
                                height: 31,
                                child: CountrySettingsLayout(),
                              ),
                              iconColor: Colors.green,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  normalHeight(),
                  Text(
                    language.app,
                    style: inter14black500(context),
                  ),
                  extraSmallHeight(),
                  SettingsContainerLayout(
                    childWidget: Column(
                      children: [
                        SettingsItemLayout(
                          icon: Icons.description,
                          title: language.aboutApp,
                          iconColor: Colors.blue,
                          onCLickFunction: () => context.push('/about'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: customDivider(context),
                        ),
                        SettingsItemLayout(
                          icon: Icons.rule,
                          title: language.terms,
                          iconColor: Theme.of(context).colorScheme.primary,
                          onCLickFunction: () => context.push('/terms'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: customDivider(context),
                        ),
                        SettingsItemLayout(
                          icon: Icons.privacy_tip,
                          title: language.privacy,
                          iconColor: Colors.red,
                          onCLickFunction: () => context.push('/privacy'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: customDivider(context),
                        ),
                        SettingsItemLayout(
                          icon: Icons.numbers,
                          title: language.appVersion,
                          iconColor: Theme.of(context).colorScheme.primary,
                          value: Text(_appVersion),
                        ),
                      ],
                    ),
                  ),
                  normalHeight(),
                  GestureDetector(
                    onTap: () => _showLogoutDialog(context),
                    child: SettingsContainerLayout(
                      childWidget: SettingsItemLayout(
                        icon: Icons.logout,
                        title: language.logout,
                        iconColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            cupertinoOverrideTheme: CupertinoThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.white,
              textTheme: CupertinoTextThemeData(
                textStyle: inter16Black600(context),
                actionTextStyle: inter12Black400(context),
              ),
            ),
          ),
          child: CupertinoAlertDialog(
            title: Text(
              language.logout,
              style: inter16Black600(context),
            ),
            content: Text(
              language.logoutMessage,
              style: inter12Black400(context),
            ),
            actions: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      language.cancel,
                      style: inter12Black400(context),
                    ),
                  ),
                ),
              ),
              BlocListener<LogoutBloc, LogoutState>(
                listener: (context, state) {
                  if (state is LogoutSuccessState) {
                    context.pop();
                    UserPreferences().clearAll();
                    context.go('/login');
                  } else if (state is LogoutErrorState) {
                    Navigator.pop(context);
                  }
                },
                child: GestureDetector(
                  onTap: () => context.read<LogoutBloc>().add(
                        SubmitLogoutEvent(),
                      ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        language.logout,
                        style: inter12Black400(context),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  showModal(String menuTitle, BuildContext context, double width) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return SingleChildScrollView(
              primary: true,
              child: GestureDetector(
                //onTap: () => closeMenu(),
                child: bottomSheetLayout(setState, menuTitle, width),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        ChangeLanguageProvider();
      });
    });
  }

  Widget bottomSheetLayout(
      StateSetter setState, String menuTitle, double width) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    menuTitle,
                    style: inter16Black600(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: customDivider(context),
            ),
            Container(
              child: LanguageSettingsLayout(),
            )
          ],
        ),
      ),
    );
  }
}
