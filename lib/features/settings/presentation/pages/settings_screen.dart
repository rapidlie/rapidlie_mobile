import 'package:flutter/material.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = "settings";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBarTemplate(
            pageTitle: "Setings",
            isSubPage: false,
          ),
        ),
        body: Container(
          child: Center(child: Text("Settings screen")),
        ),
      ),
    );
  }
}
