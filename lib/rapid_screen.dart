import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rapidlie/core/constants/color_constants.dart';
import 'package:rapidlie/features/events/presentation/pages/events_screen.dart';
import 'package:rapidlie/features/home/presentation/pages/home_screen.dart';
import 'package:rapidlie/features/invites/presentation/pages/invites_screen.dart';
import 'package:rapidlie/features/settings/presentation/pages/settings_screen.dart';

class RapidScreen extends StatefulWidget {
  static const String routeName = "rapid";

  final int currentIndex;
  const RapidScreen({Key? key, required this.currentIndex}) : super(key: key);

  @override
  State<RapidScreen> createState() => _RapidScreenState();
}

class _RapidScreenState extends State<RapidScreen> {
  late int _currentIndex;
  final currentScreen = [
    HomeScreen(),
    EventsScreen(),
    InvitesScreen(),
    SettingsScreen()
  ];
  Color activeTextColor = ColorConstants.primary;
  Color inactiveTextColor = ColorConstants.black;
  bool active = false;

  @override
  void initState() {
    _currentIndex = widget.currentIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: currentScreen[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            unselectedFontSize: 10.0,
            selectedFontSize: 10.0,
            selectedItemColor: ColorConstants.black,
            items: [
              //Home
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/home_outline.svg",
                  color: Colors.grey,
                ),
                label: 'Home',
                activeIcon: SvgPicture.asset(
                  "assets/icons/home_outline.svg",
                  color: Colors.black,
                ),
              ),
              // Events
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/events.svg",
                  color: Colors.grey,
                ),
                label: 'Events',
                activeIcon: SvgPicture.asset(
                  "assets/icons/events.svg",
                  color: Colors.black,
                ),
              ),
              // Invites
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/invite.svg",
                  color: Colors.grey,
                ),
                label: 'Invites',
                activeIcon: SvgPicture.asset(
                  "assets/icons/invite.svg",
                  color: Colors.black,
                ),
              ),
              //Setings
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/settings.svg",
                  color: Colors.grey,
                ),
                label: 'Settings',
                activeIcon: SvgPicture.asset(
                  "assets/icons/settings.svg",
                  color: Colors.black,
                ),
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
