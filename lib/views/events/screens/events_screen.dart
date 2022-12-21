import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  static const String routeName = "events";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Text("Events screen"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
