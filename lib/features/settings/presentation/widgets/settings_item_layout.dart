import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';

class SettingsItemLayout extends StatelessWidget {
  const SettingsItemLayout({
    Key? key,
    required this.icon,
    required this.title,
    this.subTitle,
    required this.value,
    required this.iconColor,
    this.onCLickFunction,
  }) : super(key: key);

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subTitle;
  final Widget value;
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(),
                    Text(
                      title,
                      style: poppins14black500(),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ],
            ),
            value
          ],
        ),
      ),
    );
  }
}
