import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rapidlie/constants/color_system.dart';
import 'package:rapidlie/views/events_screen.dart';
import 'package:rapidlie/views/home_screen.dart';
import 'package:rapidlie/views/invites_screen.dart';
import 'package:rapidlie/views/settings_screen.dart';

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
  Color activeTextColor = ColorSystem.secondary;
  Color inactiveTextColor = ColorSystem.black;
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
          body: currentScreen[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            unselectedFontSize: 10.0,
            selectedFontSize: 10.0,
            selectedItemColor: ColorSystem.secondary,
            unselectedItemColor: ColorSystem.black,
            items: [
              //Home
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/home.svg",
                  width: 20,
                  height: 20,
                ),
                label: 'Home',
                activeIcon: SvgPicture.asset(
                  "assets/icons/home_selected.svg",
                  width: 20,
                  height: 20,
                ),
              ),
              // Events
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/event.svg",
                  width: 20,
                  height: 20,
                ),
                label: 'Events',
                activeIcon: SvgPicture.asset(
                  "assets/icons/event_selected.svg",
                  width: 20,
                  height: 20,
                ),
              ),
              // Invites
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/invites.svg",
                  width: 20,
                  height: 20,
                ),
                label: 'Invites',
                activeIcon: SvgPicture.asset(
                  "assets/icons/invites_selected.svg",
                  width: 20,
                  height: 20,
                ),
              ),
              // Settings
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/settings.svg",
                  width: 20,
                  height: 20,
                ),
                label: 'Settings',
                activeIcon: SvgPicture.asset(
                  "assets/icons/settings_selected.svg",
                  width: 20,
                  height: 20,
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
