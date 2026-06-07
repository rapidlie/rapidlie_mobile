import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
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

  // Owner info — shown when showOwnerInfo is true
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
    final double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showOwnerInfo) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/placeholder.png',
                      image: eventOwnerAvatar ?? '',
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) =>
                          Image.asset('assets/images/placeholder.png'),
                      imageCacheHeight: 100,
                      imageCacheWidth: 100,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(eventOwner ?? '', style: inter14black600(context)),
                    Text(eventLocation ?? '', style: inter10Black400(context)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Container(
                width: width,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: eventImageString == null
                    ? const SizedBox.shrink()
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: RenderImage(imageUrl: eventImageString!),
                      ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(eventName, style: inter13black500(context)),
                        Row(
                          children: [
                            Text(eventDay, style: inter10Black400(context)),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Container(
                                height: 10,
                                width: 1,
                                color:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Text(eventDate, style: inter10Black400(context)),
                          ],
                        ),
                      ],
                    ),
                    if (showStatusBadge) _StatusBadge(status: inviteStatus),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isAccepted = status == 'accepted';
    final isDeclined = status == 'declined';

    return Container(
      decoration: BoxDecoration(
        color: isAccepted
            ? const Color.fromARGB(55, 76, 175, 79)
            : isDeclined
                ? const Color.fromARGB(55, 244, 67, 54)
                : const Color.fromARGB(55, 0, 0, 0),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text(
        isAccepted ? 'GOING' : isDeclined ? 'DECLINED' : 'PENDING',
        style: GoogleFonts.inter(
          color: isAccepted
              ? Colors.green
              : isDeclined
                  ? Colors.red
                  : Colors.white,
          fontSize: 9.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
