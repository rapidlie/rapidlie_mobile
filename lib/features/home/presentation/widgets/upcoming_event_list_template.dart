import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';

class UpcomingEventListTemplate extends StatelessWidget {
  final String eventName;
  final String eventLocation;
  final String eventDate;
  final String eventDay;
  final String? eventImageString;
  final String? eventId;
  const UpcomingEventListTemplate({
    Key? key,
    required this.eventName,
    required this.eventLocation,
    required this.eventDate,
    required this.eventDay,
    required this.eventImageString,
    this.eventId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Container(
              width: width * 0.9,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              child: eventImageString == null
                  ? Container()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        child: Image.network(
                          eventImageString!,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 20,
          right: 10,
          child: Container(
            height: 80,
            width: width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(189, 255, 255, 255),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10),
                  child: Text(
                    eventDate,
                    style: inter12Red500(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 3),
                  child: Text(
                    eventName,
                    style: inter14black600(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    eventLocation,
                    style: inter10CharcoalBlack400(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
