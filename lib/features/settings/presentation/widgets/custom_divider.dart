import 'package:flutter/material.dart';

Widget customDivider(BuildContext context) {
  return Container(
    height: 0.5,
    color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
  );
}
