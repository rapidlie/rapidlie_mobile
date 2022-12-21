import 'package:flutter/material.dart';
import 'package:rapidlie/constants/color_system.dart';

class EventsScreen extends StatefulWidget {
  static const String routeName = "events";

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List eventsCreated = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: eventsCreated.length == 0
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You haven\'t created any event. Click the button below to add your next event',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                        color: ColorSystem.secondary,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorSystem.secondary,
                      ),
                      child: Icon(
                        Icons.add,
                        color: ColorSystem.white,
                      ),
                    )
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: Center(
                        child: Text(
                          "Events screen",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
