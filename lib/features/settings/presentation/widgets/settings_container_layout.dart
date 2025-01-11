import 'package:flutter/material.dart';

import 'package:rapidlie/core/constants/feature_constants.dart';

class SettingsContainerLayout extends StatelessWidget {
  final Widget childWidget;
  SettingsContainerLayout({
    Key? key,
    required this.childWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: childWidget,
    );
  }
}
