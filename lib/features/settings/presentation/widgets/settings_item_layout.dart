import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';

class SettingsItemLayout extends StatelessWidget {
  const SettingsItemLayout({
    Key? key,
    required this.icon,
    required this.title,
    this.subTitle,
    this.value,
    required this.iconColor,
    this.onCLickFunction,
  }) : super(key: key);

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subTitle;
  final Widget? value;
  final Function()? onCLickFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: GestureDetector(
        onTap: onCLickFunction,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: iconColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: inter14black500(context),
                ),
              ],
            ),
            value ?? SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
