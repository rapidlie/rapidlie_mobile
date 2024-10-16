import 'package:flutter/material.dart';
import 'package:rapidlie/core/widgets/general_event_list_template.dart';

class EventListTemplate extends StatelessWidget {
  final Widget trailingWidget;
  final String eventOwner;
  final String eventName;
  final String eventLocation;
  final String eventDate;
  final String eventDay;
  final String eventImageString;
  const EventListTemplate({
    Key? key,
    required this.trailingWidget,
    required this.eventOwner,
    required this.eventName,
    required this.eventLocation,
    required this.eventDate,
    required this.eventDay,
    required this.eventImageString,
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventOwner,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      eventLocation,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
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
            trailingWidget: trailingWidget,
            eventName: eventName,
            eventDate: eventDate,
            eventDay: eventDay,
            eventImageString: eventImageString,
          )
        ],
      ),
    );
  }
}
