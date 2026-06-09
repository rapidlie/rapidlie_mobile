import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/utils/app_theme.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/user/models/user_model.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class ProfileSettingsScreen extends StatelessWidget {
  final UserModel userProfile;

  const ProfileSettingsScreen({Key? key, required this.userProfile})
      : super(key: key);

  static ProfileSettingsScreen fromState(GoRouterState state) {
    final data = state.extra as Map<String, dynamic>;
    return ProfileSettingsScreen(
      userProfile: data['userProfile'] as UserModel,
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: language.profileSettings,
          isSubPage: true,
        ),
      ),
      body: SingleChildScrollView(
        physics:
            const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar hero card ──────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 28.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.headerStart,
                    AppColors.headerEnd,
                    AppColors.headerEnd,
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Column(
                children: [
                  // Avatar with gradient ring
                  Container(
                    width: 86.r,
                    height: 86.r,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFE8E8E8), Color(0xFF888888)],
                      ),
                    ),
                    padding: const EdgeInsets.all(2.5),
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/placeholder.png',
                        image: userProfile.avatar,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (_, __, ___) =>
                            Image.asset('assets/images/placeholder.png'),
                        imageCacheHeight: 172,
                        imageCacheWidth: 172,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 28.h),

            // ── Activity section ──────────────────────────────────────────
            _SectionLabel(label: 'Activity'),
            SizedBox(height: 8.h),
            _Card(
              child: Column(
                children: [
                  _Row(
                    icon: Icons.confirmation_number_rounded,
                    iconBg: AppColors.primary,
                    title: 'My Tickets',
                    onTap: () => context.pushNamed('tickets'),
                  ),
                  _Divider(),
                  _Row(
                    icon: Icons.volunteer_activism_rounded,
                    iconBg: AppColors.accentEmerald,
                    title: 'My Contributions',
                    onTap: () => context.pushNamed('my_contributions'),
                  ),
                  _Divider(),
                  _Row(
                    icon: Icons.mail_rounded,
                    iconBg: AppColors.accentAmber,
                    title: 'Pending Invitations',
                    onTap: () => context.pushNamed('pending_invitations'),
                  ),
                ],
              ),
            ),

            SizedBox(height: 28.h),

            // ── Social section ────────────────────────────────────────────
            _SectionLabel(label: 'Social'),
            SizedBox(height: 8.h),
            _Card(
              child: _Row(
                icon: Icons.people_rounded,
                iconBg: AppColors.accentCyan,
                title: 'Find Friends',
                onTap: () => context.pushNamed('contacts'),
              ),
            ),

            SizedBox(height: 28.h),

            // ── Account section ───────────────────────────────────────────
            _SectionLabel(label: 'Account'),
            SizedBox(height: 8.h),
            _Card(
              child: Column(
                children: [
                  _Row(
                    icon: Icons.tune_rounded,
                    iconBg: const Color(0xFF6366F1),
                    title: 'App Settings',
                    onTap: () => context.pushNamed('app_settings'),
                  ),
                  _Divider(),
                  _Row(
                    icon: Icons.lock_rounded,
                    iconBg: const Color(0xFF0EA5E9),
                    title: language.changePassword,
                    onTap: () => context.push('/change_password'),
                  ),
                  _Divider(),
                  _Row(
                    icon: Icons.delete_rounded,
                    iconBg: AppColors.error,
                    title: language.deleteAccount,
                    titleColor: AppColors.error,
                    showChevron: false,
                    onTap: () => context.push('/delete_account'),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

// ── Shared Apple-style widgets ────────────────────────────────────────────────

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

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

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

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 54.w),
      child: Divider(
        height: 0.5,
        thickness: 0.5,
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final Color? titleColor;
  final bool showChevron;
  final VoidCallback? onTap;

  const _Row({
    required this.icon,
    required this.iconBg,
    required this.title,
    this.titleColor,
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
                  color: titleColor ?? Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            if (showChevron)
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
