import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rapidlie/core/constants/color_constants.dart';
import 'package:rapidlie/views/events/screens/events_screen.dart';
import 'package:rapidlie/views/home/screens/home_screen.dart';
import 'package:rapidlie/views/invites/screens/invites_screen.dart';
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
                icon: Image.asset(
                  "assets/icons/home.png",
                  width: 20,
                  height: 20,
                ),
                label: 'Home',
                activeIcon: Image.asset(
                  "assets/icons/home_selected.png",
                  width: 26,
                  height: 26,
                ),
              ),
              // Events
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/add_event.png",
                  width: 20,
                  height: 20,
                ),
                label: 'Events',
                activeIcon: Image.asset(
                  "assets/icons/add_event_selected.png",
                  width: 26,
                  height: 26,
                ),
              ),
              // Invites
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/invites.png",
                  width: 20,
                  height: 20,
                ),
                label: 'Invites',
                activeIcon: Image.asset(
                  "assets/icons/invites_selected.png",
                  width: 26,
                  height: 26,
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
