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
    return Container(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Container(
                  width: width,
                  height: 250,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8)),
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
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
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
