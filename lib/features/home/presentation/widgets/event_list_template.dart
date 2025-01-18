import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/widgets/general_event_list_template.dart';

class EventListTemplate extends StatelessWidget {
  //final Widget trailingWidget;
  final String eventOwner;
  final String eventName;
  final String eventLocation;
  final String eventDate;
  final String eventDay;
  final String eventImageString;
  final String? eventId;
  final bool hasLikedEvent;
  final String? eventOwnerAvatar;
  const EventListTemplate({
    Key? key,
    required this.eventOwner,
    required this.eventName,
    required this.eventLocation,
    required this.eventDate,
    required this.eventDay,
    required this.eventImageString,
    this.eventId,
    required this.hasLikedEvent,
    this.eventOwnerAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/placeholder.png',
                      image: eventOwnerAvatar!,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) =>
                          Image.asset('assets/images/placeholder.png'),
                      imageCacheHeight: 100,
                      imageCacheWidth: 100,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventOwner,
                      style: GoogleFonts.inter(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      eventLocation,
                      style: GoogleFonts.inter(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          GeneralEventListTemplate(
            eventName: eventName,
            eventDate: eventDate,
            eventDay: eventDay,
            eventImageString: eventImageString,
            eventId: eventId,
            hasLikedEvent: hasLikedEvent,
          )
        ],
      ),
    );
  }
}
