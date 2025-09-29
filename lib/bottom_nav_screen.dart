import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/features/events/presentation/pages/events_screen.dart';
import 'package:rapidlie/features/home/presentation/pages/home_screen.dart';
import 'package:rapidlie/features/invites/presentation/pages/invites_screen.dart';
import 'package:rapidlie/features/settings/presentation/pages/settings_screen.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class BottomNavScreen extends StatefulWidget {
  final int currentIndex;
  const BottomNavScreen({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  late int _currentIndex;
  final currentScreen = [
    HomeScreen(),
    EventsScreen(),
    InvitesScreen(),
    SettingsScreen()
  ];

  var language;
  bool active = false;

  @override
  void initState() {
    _currentIndex = widget.currentIndex;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);
    return PopScope(
      canPop: false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: currentScreen[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            unselectedFontSize: 10.0,
            selectedFontSize: 12.0,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: inter12Black500(context),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            items: [
              //Home
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/home-(Regular).svg",
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                label: language.home,
                activeIcon: SvgPicture.asset(
                  "assets/icons/home-(Filled).svg",
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              // Events
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/blogger-(Regular).svg",
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                label: language.events,
                activeIcon: SvgPicture.asset(
                  "assets/icons/blogger-(Filled).svg",
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              // Invites
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/alarm-clock-alt-(Regular).svg",
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                label: language.invites,
                activeIcon: SvgPicture.asset(
                  "assets/icons/alarm-clock-alt-(Filled).svg",
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              //Setings
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/settings-(Regular).svg",
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                label: language.settings,
                activeIcon: SvgPicture.asset(
                  "assets/icons/settings-(Filled).svg",
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
    );
  }
}
