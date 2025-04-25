import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';
import 'package:rapidlie/features/events/blocs/like_bloc/like_event_bloc.dart';
import 'package:rapidlie/features/events/blocs/like_bloc/like_event_event.dart';
import 'package:rapidlie/features/events/blocs/unlike_bloc/unlike_event_bloc.dart';
import 'package:rapidlie/features/events/blocs/unlike_bloc/unlike_event_event.dart';

class GeneralEventListTemplate extends StatefulWidget {
  //final Widget trailingWidget;
  final String eventName;
  final String? eventImageString;
  final String eventDate;
  final String eventDay;
  final bool? eventLiked;
  final String? eventId;
  final bool hasLikedEvent;
  GeneralEventListTemplate({
    Key? key,
    required this.eventName,
    this.eventImageString,
    required this.eventDate,
    required this.eventDay,
    this.eventLiked,
    this.eventId,
    required this.hasLikedEvent,
  }) : super(key: key);

  @override
  State<GeneralEventListTemplate> createState() =>
      _GeneralEventListTemplateState();
}

class _GeneralEventListTemplateState extends State<GeneralEventListTemplate> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = widget.hasLikedEvent;
  }

  void toggleLike() {
    if (isLiked == false) {
      setState(() {
        isLiked = true;
      });
      context.read<LikeEventBloc>().add(LikeToggled(widget.eventId!));
      context.read<PrivateEventBloc>().add(GetPrivateEvents());
    } else {
      setState(() {
        isLiked = false;
      });
      context.read<UnlikeEventBloc>().add(UnlikeToggled(widget.eventId!));
      context.read<PrivateEventBloc>().add(GetPrivateEvents());
    }
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
                      child: Image.network(
                        widget.eventImageString!,
                        fit: BoxFit.fitWidth,
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
                      style: GoogleFonts.inter(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          widget.eventDay,
                          style: GoogleFonts.inter(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
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
                          widget.eventDate,
                          style: GoogleFonts.inter(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        toggleLike();
                      },
                      child: Icon(
                        isLiked
                            ? Icons.favorite_sharp
                            : Icons.favorite_border_sharp,
                        size: 25,
                        color: isLiked ? Colors.red : Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.bookmark_border_sharp,
                        size: 25,
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
