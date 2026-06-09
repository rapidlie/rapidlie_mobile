import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/utils/app_theme.dart';
import 'package:rapidlie/core/utils/render_image.dart';

class EventCard extends StatelessWidget {
  final String eventName;
  final String? eventImageString;
  final String eventDate;
  final String eventDay;
  final String? eventId;
  final bool hasLikedEvent;
  final String inviteStatus;
  final bool showStatusBadge;

  final bool showOwnerInfo;
  final String? eventOwner;
  final String? eventOwnerAvatar;
  final String? eventLocation;

  const EventCard({
    Key? key,
    required this.eventName,
    this.eventImageString,
    required this.eventDate,
    required this.eventDay,
    this.eventId,
    required this.hasLikedEvent,
    required this.inviteStatus,
    required this.showStatusBadge,
    this.showOwnerInfo = false,
    this.eventOwner,
    this.eventOwnerAvatar,
    this.eventLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Owner row
          if (showOwnerInfo) ...[
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18.r,
                    backgroundImage: (eventOwnerAvatar != null &&
                            eventOwnerAvatar!.isNotEmpty)
                        ? NetworkImage(eventOwnerAvatar!)
                        : null,
                    backgroundColor:
                        AppColors.primary.withValues(alpha: 0.18),
                    child: (eventOwnerAvatar == null ||
                            eventOwnerAvatar!.isEmpty)
                        ? Icon(Icons.person,
                            size: 16.sp, color: AppColors.primary)
                        : null,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      eventOwner ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (eventLocation != null && eventLocation!.isNotEmpty) ...[
                    Icon(Icons.location_on_rounded,
                        size: 13.sp,
                        color: Theme.of(context).colorScheme.outline),
                    SizedBox(width: 2.w),
                    Flexible(
                      child: Text(
                        eventLocation!,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          // Card image with overlays
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  eventImageString != null && eventImageString!.isNotEmpty
                      ? RenderImage(
                          imageUrl: eventImageString!,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.headerStart,
                                AppColors.headerEnd,
                              ],
                            ),
                          ),
                          child: Icon(Icons.event_rounded,
                              size: 48.sp,
                              color:
                                  AppColors.primary.withValues(alpha: 0.5)),
                        ),

                  // Bottom gradient overlay
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 120.h,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.70),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Text on overlay (event name + location)
                  Positioned(
                    left: 12.w,
                    right: 12.w,
                    bottom: 12.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          eventName,
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (eventLocation != null &&
                            eventLocation!.isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded,
                                  size: 12.sp,
                                  color:
                                      Colors.white.withValues(alpha: 0.85)),
                              SizedBox(width: 3.w),
                              Flexible(
                                child: Text(
                                  eventLocation!,
                                  style: GoogleFonts.inter(
                                    fontSize: 11.sp,
                                    color:
                                        Colors.white.withValues(alpha: 0.85),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Status badge — top-left
                  if (showStatusBadge)
                    Positioned(
                      top: 10.h,
                      left: 10.w,
                      child: _StatusBadge(status: inviteStatus),
                    ),

                  // Date pill — top-right
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: _DatePill(
                        eventDay: eventDay, eventDate: eventDate),
                  ),
                ],
              ),
            ),
          ),

          // Bottom meta row
          Padding(
            padding:
                EdgeInsets.only(top: 10.h, left: 2.w, right: 2.w),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded,
                    size: 13.sp,
                    color: Theme.of(context).colorScheme.outline),
                SizedBox(width: 5.w),
                Text(
                  '$eventDay  ·  $eventDate',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                const Spacer(),
                Icon(
                  hasLikedEvent
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 16.sp,
                  color: hasLikedEvent
                      ? AppColors.accentRose
                      : Theme.of(context).colorScheme.outline,
                ),
                SizedBox(width: 4.w),
                Text(
                  '0',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DatePill extends StatelessWidget {
  final String eventDay;
  final String eventDate;

  const _DatePill({required this.eventDay, required this.eventDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1C1C1C), Color(0xFF2C2C2C)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '$eventDay · $eventDate',
        style: GoogleFonts.inter(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final String label;

    switch (status) {
      case 'accepted':
        bg = AppColors.accentEmerald.withValues(alpha: 0.85);
        fg = Colors.white;
        label = 'GOING';
        break;
      case 'declined':
        bg = AppColors.accentRose.withValues(alpha: 0.85);
        fg = Colors.white;
        label = 'DECLINED';
        break;
      default:
        bg = Colors.black.withValues(alpha: 0.55);
        fg = Colors.white.withValues(alpha: 0.9);
        label = 'PENDING';
    }

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
            color: Colors.white.withValues(alpha: 0.25), width: 0.5),
      ),
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 9.w),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: fg,
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
