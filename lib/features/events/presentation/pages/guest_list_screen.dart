import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/utils/app_theme.dart';
import 'package:rapidlie/core/utils/render_image.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/events/models/event_model.dart';

class GuestListScreen extends StatelessWidget {
  final List<Invitation>? guests;
  const GuestListScreen({Key? key, this.guests}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = guests ?? [];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: 'Guest List',
          isSubPage: true,
          trailingWidget: list.isNotEmpty
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${list.length}',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : null,
        ),
      ),
      body: list.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.group_outlined,
                      size: 54, color: theme.colorScheme.outline),
                  const SizedBox(height: 12),
                  Text(
                    'No guests yet',
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Invite people to this event',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: theme.colorScheme.outline),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: list.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: theme.colorScheme.outline.withValues(alpha: 0.12),
                indent: 56,
              ),
              itemBuilder: (_, i) {
                final invitation = list[i];
                final name = invitation.user.name;
                final avatar = invitation.user.avatar;
                final status = invitation.status;

                final statusColor = status == 'accepted'
                    ? AppColors.accentEmerald
                    : status == 'declined'
                        ? const Color(0xFFEF4444)
                        : AppColors.accentAmber;

                final statusLabel = status == 'accepted'
                    ? 'Accepted'
                    : status == 'declined'
                        ? 'Declined'
                        : 'Pending';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                          ),
                        ),
                        padding: const EdgeInsets.all(1.5),
                        child: ClipOval(
                          child: avatar != null && avatar.isNotEmpty
                              ? RenderImage(
                                  imageUrl: avatar,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: isDark
                                      ? AppColors.darkCard
                                      : theme.colorScheme.surfaceContainerHighest,
                                  child: Icon(Icons.person_rounded,
                                      size: 20,
                                      color: theme.colorScheme.outline),
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Name
                      Expanded(
                        child: Text(
                          name,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: statusColor.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Text(
                          statusLabel,
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
