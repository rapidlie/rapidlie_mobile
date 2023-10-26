import 'package:flutter/material.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';

class InvitesScreen extends StatelessWidget {
  static const String routeName = "invites";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBarTemplate(
            pageTitle: "Invites",
            isSubPage: false,
          ),
        ),
        body: Container(
          child: Center(child: Text("Invites screen")),
        ),
      ),
    );
  }
}
