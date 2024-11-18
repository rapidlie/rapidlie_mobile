import 'package:flutter/material.dart';
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
                    color: Colors.grey.shade300,
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
                      style: TextStyle(
                        fontSize: 13.0,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      eventLocation,
                      style: TextStyle(
                        fontSize: 10.0,
                        fontFamily: "Poppins",
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
