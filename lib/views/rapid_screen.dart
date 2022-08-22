import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rapidlie/constants/color_system.dart';

class RapidScreen extends StatefulWidget {
  @override
  State<RapidScreen> createState() => _RapidScreenState();
}

class _RapidScreenState extends State<RapidScreen> {
  late int _currentIndex;
  final currentScreen = [];
  Color activeTextColor = ColorSystem.primary;
  Color inactiveTextColor = ColorSystem.black;
  bool active = false;

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
            selectedItemColor: ColorSystem.primary,
            unselectedItemColor: ColorSystem.black,
            items: [
              //home or projects
              BottomNavigationBarItem(
                icon: SvgPicture.asset("assets/icons/home.svg"),
                label: 'Home',
                activeIcon: SvgPicture.asset("assets/icons/home_selected.svg"),
              ),
              // Events
              BottomNavigationBarItem(
                icon: SvgPicture.asset("assets/icons/event.svg"),
                label: 'Wallet',
                activeIcon: SvgPicture.asset("assets/icons/event_selected.svg"),
              ),
              // Invites
              BottomNavigationBarItem(
                icon: SvgPicture.asset("assets/icons/invites.svg"),
                label: 'Referrals',
                activeIcon:
                    SvgPicture.asset("assets/icons/invites_selected.svg"),
              ),
              // Settings
              BottomNavigationBarItem(
                icon: SvgPicture.asset("assets/icons/settings.svg"),
                label: 'Notifications',
                activeIcon:
                    SvgPicture.asset("assets/icons/settings_selected.svg"),
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
