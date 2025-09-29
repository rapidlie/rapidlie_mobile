import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
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
  final String inviteStatus;
  final bool showStatusBadge;

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
    required this.inviteStatus,
    required this.showStatusBadge,
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
                      image: eventOwnerAvatar ?? '',
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
                    Text(eventOwner, style: inter14black600(context)),
                    Text(eventLocation, style: inter10Black400(context))
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
            inviteStatus: inviteStatus,
            showStatusBadge: showStatusBadge,
          )
        ],
      ),
    );
  }
}
