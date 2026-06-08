import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FlashNotificationsTemplate extends StatelessWidget {
  final String noificationTitle;
  final String noificationBody;

  const FlashNotificationsTemplate(
      {super.key,
      required this.noificationTitle,
      required this.noificationBody});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(left: 10),
      height: 100,
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1A2235), const Color(0xFF111827)]
              : [primary.withValues(alpha: 0.08), primary.withValues(alpha: 0.03)],
        ),
        border: Border.all(
          color: primary.withValues(alpha: isDark ? 0.25 : 0.15),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 7,
                  width: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    noificationTitle,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              noificationBody,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
