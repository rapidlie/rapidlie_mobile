import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';

class GeneralEventListTemplate extends StatelessWidget {
  final Widget trailingWidget;
  final String eventName;
  String? eventImageString;
  final String eventDate;
  final String eventDay;
  GeneralEventListTemplate({
    Key? key,
    required this.trailingWidget,
    required this.eventName,
    this.eventImageString,
    required this.eventDate,
    required this.eventDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: width,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.grey,
          ),
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
        SizedBox(
          height: 10,
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
                    eventName,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        eventDay,
                        style: TextStyle(
                          fontSize: 11.0,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          height: 10,
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        eventDate,
                        style: TextStyle(
                          fontSize: 11.0,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailingWidget
            ],
          ),
        )
      ],
    );
  }
}
