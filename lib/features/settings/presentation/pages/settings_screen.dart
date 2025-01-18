import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/login/presentation/pages/login_screen.dart';
import 'package:rapidlie/features/logout/bloc/logout_bloc.dart';
import 'package:rapidlie/features/settings/blocs/profile_bloc/profile_bloc.dart';
import 'package:rapidlie/features/settings/presentation/pages/profile_settings_screen.dart';
import 'package:rapidlie/features/settings/presentation/widgets/settings_container_layout.dart';
import 'package:rapidlie/features/settings/providers/change_language_provider.dart';
import 'package:rapidlie/features/settings/presentation/widgets/country_settings_layout.dart';
import 'package:rapidlie/features/settings/presentation/widgets/language_settings_layout.dart';
import 'package:rapidlie/features/settings/presentation/widgets/settings_item_layout.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = "settings";

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '';
  late var language;
  /* PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  ); */

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetProfileEvent());
    //_initPackageInfo();
    //_fetchAppVersion();
  }

  /* Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  } */

  /* Future<void> _fetchAppVersion() async {
    setState(() {
      _appVersion = _packageInfo.version;
    });
  } */

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfileLoadedState) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => ProfileSettingsScreen());
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
                                            style: inter15black500(),
                                          ),
                                          Text(
                                            state.userProfile.phone,
                                            style: inter10CharcoalBlack400(),
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
                          Get.to(() => ProfileSettingsScreen());
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
                                        //color: Colors.grey.shade600,
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
                                          style: inter15black500(),
                                        ),
                                        Text(
                                          UserPreferences().getTelephone(),
                                          style: inter10CharcoalBlack400(),
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
                    style: poppins14black500(),
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
                                  style: poppins13black400(),
                                ),
                              ),
                              iconColor: Colors.blue,
                              onCLickFunction: () =>
                                  showModal(language.language, context),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: Container(
                                height: 1,
                                color: const Color.fromARGB(255, 240, 239, 239),
                              ),
                            ),
                            SettingsItemLayout(
                              icon: Icons.flag,
                              title: language.country,
                              value: Container(
                                height: 30,
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
                    "App",
                    style: poppins14black500(),
                  ),
                  extraSmallHeight(),
                  SettingsContainerLayout(
                    childWidget: Column(
                      children: [
                        SettingsItemLayout(
                          icon: Icons.description,
                          title: "About",
                          iconColor: Colors.blue,
                          onCLickFunction: () {},
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Container(
                            height: 1,
                            color: const Color.fromARGB(255, 240, 239, 239),
                          ),
                        ),
                        SettingsItemLayout(
                          icon: Icons.rule,
                          title: "Terms and conditions",
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
                          icon: Icons.privacy_tip,
                          title: "Privacy policy",
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
                          icon: Icons.numbers,
                          title: "App version",
                          iconColor: Colors.black,
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
                        title: "Logout",
                        iconColor: Colors.black,
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
                textStyle: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                actionTextStyle: inter12CharcoalBlack400(),
              ),
            ),
          ),
          child: CupertinoAlertDialog(
            title: Text(
              'Logout',
            ),
            content: Text(
              'Are you sure you want to logout?',
            ),
            actions: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      "Cancel",
                      style: inter12CharcoalBlack400(),
                    ),
                  ),
                ),
              ),
              BlocListener<LogoutBloc, LogoutState>(
                listener: (context, state) {
                  print(state);
                  if (state is LogoutSuccessState) {
                    Navigator.pop(context);
                    UserPreferences().clearAll();
                    Navigator.pushReplacementNamed(
                        context, LoginScreen.routeName);
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
                        "Logout",
                        style: inter12CharcoalBlack400(),
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

  showModal(String menuTitle, BuildContext context) {
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
                child: bottomSheetLayout(setState, menuTitle),
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

  Widget bottomSheetLayout(StateSetter setState, String menuTitle) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: CustomColors.colorFromHex("#F2F4F5"),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
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
                    style: TextStyle(
                      fontSize: 16.0,
                      color: CustomColors.charcoalBlack,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  /* GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorConstants.colorFromHex("#FFFFFF"),
                      ),
                      child: Icon(
                        Icons.close,
                        color: ColorConstants.closeButtonColor,
                        size: 20,
                      ),
                    ),
                  ), */
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                color: CustomColors.lightGray,
                height: 1,
                width: Get.width,
              ),
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
