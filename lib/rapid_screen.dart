import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';
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
  Color activeTextColor = CustomColors.primary;
  Color inactiveTextColor = CustomColors.black;
  bool active = false;

  @override
  void initState() {
    _currentIndex = widget.currentIndex;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: currentScreen[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            unselectedFontSize: 10.0,
            selectedFontSize: 10.0,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            items: [
              //Home
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/home-(Regular).svg",
                ),
                label: 'Home',
                activeIcon: SvgPicture.asset(
                  "assets/icons/home-(Filled).svg",
                ),
              ),
              // Events
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/blogger-(Regular).svg",
                ),
                label: 'Events',
                activeIcon: SvgPicture.asset(
                  "assets/icons/blogger-(Filled).svg",
                ),
              ),
              // Invites
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/alarm-clock-alt-(Regular).svg",
                ),
                label: 'Invites',
                activeIcon: SvgPicture.asset(
                  "assets/icons/alarm-clock-alt-(Filled).svg",
                ),
              ),
              //Setings
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/settings-(Regular).svg",
                ),
                label: 'Settings',
                activeIcon: SvgPicture.asset(
                  "assets/icons/settings-(Filled).svg",
                ),
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
