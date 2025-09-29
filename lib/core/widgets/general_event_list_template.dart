import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/render_image.dart';

class GeneralEventListTemplate extends StatefulWidget {
  //final Widget trailingWidget;
  final String eventName;
  final String? eventImageString;
  final String eventDate;
  final String eventDay;
  final String? eventId;
  final bool hasLikedEvent;
  final String inviteStatus;
  final bool showStatusBadge;

  GeneralEventListTemplate({
    Key? key,
    required this.eventName,
    this.eventImageString,
    required this.eventDate,
    required this.eventDay,
    this.eventId,
    required this.hasLikedEvent,
    required this.inviteStatus,
    required this.showStatusBadge,
  }) : super(key: key);

  @override
  State<GeneralEventListTemplate> createState() =>
      _GeneralEventListTemplateState();
}

class _GeneralEventListTemplateState extends State<GeneralEventListTemplate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            width: width,
            height: 250,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(8)),
            child: widget.eventImageString == null
                ? Container()
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      child: RenderImage(
                        imageUrl: widget.eventImageString!,
                      ),
                    ),
                  ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.eventName,
                      style: inter13black500(context),
                    ),
                    Row(
                      children: [
                        Text(widget.eventDay, style: inter10Black400(context)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            height: 10,
                            width: 1,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(widget.eventDate, style: inter10Black400(context)),
                      ],
                    ),
                  ],
                ),
                widget.showStatusBadge
                    ? statusContainer(widget.inviteStatus)
                    : SizedBox.shrink(),
              ],
            ),
          )
        ],
      ),
    );
  }

  statusContainer(String statusText) {
    return Container(
      decoration: BoxDecoration(
          color: statusText == "accepted"
              ? const Color.fromARGB(55, 76, 175, 79)
              : statusText == "declined"
                  ? const Color.fromARGB(55, 244, 67, 54)
                  : const Color.fromARGB(55, 0, 0, 0),
          borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Text(
          statusText == "accepted"
              ? "GOING"
              : statusText == "declined"
                  ? "DECLINED"
                  : "PENDING",
          style: GoogleFonts.inter(
            color: statusText == "accepted"
                ? Colors.green
                : statusText == "declined"
                    ? Colors.red
                    : Colors.white,
            fontSize: 9.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
