import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/app_theme.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/logout/bloc/logout_bloc.dart';
import 'package:rapidlie/features/settings/blocs/profile_bloc/profile_bloc.dart';
import 'package:rapidlie/features/settings/presentation/widgets/custom_divider.dart';
import 'package:rapidlie/features/settings/providers/change_language_provider.dart';
import 'package:rapidlie/features/settings/presentation/widgets/country_settings_layout.dart';
import 'package:rapidlie/features/settings/presentation/widgets/language_settings_layout.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

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
    final double width = MediaQuery.of(context).size.width;
    language = AppLocalizations.of(context);

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBarTemplate(
            pageTitle: language.settings,
            isSubPage: false,
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Profile card ──
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  final String name;
                  final String phone;
                  final String? avatarUrl;
                  final void Function() onTap;

                  if (state is ProfileLoadedState) {
                    name = state.userProfile.name;
                    phone = state.userProfile.phone ?? '';
                    avatarUrl = state.userProfile.avatar;
                    onTap = () => context.push('/profile',
                        extra: {'userProfile': state.userProfile});
                  } else {
                    name = UserPreferences().getUserName();
                    phone = UserPreferences().getTelephone();
                    avatarUrl = null;
                    onTap = () =>
                        context.push('/profile', extra: {'userProfile': null});
                  }

                  return GestureDetector(
                    onTap: onTap,
                    child: _AppleCard(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 14.h),
                        child: Row(
                          children: [
                            // Avatar with gradient border
                            Container(
                              width: 56.r,
                              height: 56.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.secondary,
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.all(2),
                              child: ClipOval(
                                child: avatarUrl != null &&
                                        avatarUrl.isNotEmpty
                                    ? FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/images/placeholder.png',
                                        image: avatarUrl,
                                        fit: BoxFit.cover,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                                    'assets/images/placeholder.png'),
                                        imageCacheHeight: 112,
                                        imageCacheWidth: 112,
                                      )
                                    : FadeInImage(
                                        image: const AssetImage(
                                            'assets/images/placeholder.png'),
                                        fit: BoxFit.cover,
                                        placeholder: const AssetImage(
                                            'assets/images/placeholder.png'),
                                      ),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    phone,
                                    style: GoogleFonts.inter(
                                      fontSize: 13.sp,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16.sp,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 28.h),

              // ── General section ──
              _SectionLabel(label: language.general),
              SizedBox(height: 8.h),
              _AppleCard(
                child: Consumer<ChangeLanguageProvider>(
                  builder: (context, provider, child) {
                    final localeName = provider.applicationLocale ==
                            const Locale("en")
                        ? language.english
                        : provider.applicationLocale == const Locale("de")
                            ? language.german
                            : provider.applicationLocale == const Locale("fr")
                                ? language.french
                                : language.english;

                    return Column(
                      children: [
                        _AppleRow(
                          icon: Icons.language_rounded,
                          iconBg: AppColors.accentCyan,
                          title: language.language,
                          trailing: Text(
                            localeName,
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          onTap: () =>
                              showModal(language.language, context, width),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 54.w),
                          child: customDivider(context),
                        ),
                        _AppleRow(
                          icon: Icons.flag_rounded,
                          iconBg: AppColors.accentEmerald,
                          title: language.country,
                          trailing: SizedBox(
                            height: 31,
                            child: CountrySettingsLayout(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              SizedBox(height: 28.h),

              // ── App section ──
              _SectionLabel(label: language.app),
              SizedBox(height: 8.h),
              _AppleCard(
                child: Column(
                  children: [
                    _AppleRow(
                      icon: Icons.description_rounded,
                      iconBg: AppColors.accentCyan,
                      title: language.aboutApp,
                      onTap: () => context.push('/about'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 54.w),
                      child: customDivider(context),
                    ),
                    _AppleRow(
                      icon: Icons.rule_rounded,
                      iconBg: AppColors.primary,
                      title: language.terms,
                      onTap: () => context.push('/terms'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 54.w),
                      child: customDivider(context),
                    ),
                    _AppleRow(
                      icon: Icons.privacy_tip_rounded,
                      iconBg: AppColors.accentAmber,
                      title: language.privacy,
                      onTap: () => context.push('/privacy'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 54.w),
                      child: customDivider(context),
                    ),
                    _AppleRow(
                      icon: Icons.numbers_rounded,
                      iconBg: AppColors.accentEmerald,
                      title: language.appVersion,
                      trailing: Text(
                        _appVersion,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 28.h),

              // ── Logout section ──
              _AppleCard(
                child: _AppleRow(
                  icon: Icons.logout_rounded,
                  iconBg: AppColors.error,
                  title: language.logout,
                  titleColor: AppColors.error,
                  showChevron: false,
                  onTap: () => _showLogoutDialog(context),
                ),
              ),

              SizedBox(height: 40.h),
            ],
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
      shape: const RoundedRectangleBorder(
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
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 2),
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
            LanguageSettingsLayout(),
          ],
        ),
      ),
    );
  }
}

// ── Reusable Apple-style card ──
class _AppleCard extends StatelessWidget {
  final Widget child;
  const _AppleCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ── iOS-style section header ──
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 2.h),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.outline,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ── Single row inside an Apple card ──
class _AppleRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final Color? titleColor;
  final Widget? trailing;
  final bool showChevron;
  final VoidCallback? onTap;

  const _AppleRow({
    required this.icon,
    required this.iconBg,
    required this.title,
    this.titleColor,
    this.trailing,
    this.showChevron = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
        child: Row(
          children: [
            // Colored icon square
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: Colors.white, size: 18.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: titleColor ??
                      Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            if (trailing != null) trailing!,
            if (showChevron && trailing == null)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.sp,
                color: Theme.of(context).colorScheme.outline,
              ),
          ],
        ),
      ),
    );
  }
}
