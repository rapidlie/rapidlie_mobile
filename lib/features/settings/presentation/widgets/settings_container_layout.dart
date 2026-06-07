import 'package:flutter/material.dart';

import 'package:rapidlie/core/constants/feature_constants.dart';

class SettingsContainerLayout extends StatelessWidget {
  final Widget childWidget;
  const SettingsContainerLayout({
    Key? key,
    required this.childWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: childWidget,
    );
  }
}
