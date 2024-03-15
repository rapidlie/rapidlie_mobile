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
  }) : super(key: key);

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subTitle;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(
              icon,
              color: Colors.blue,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: poppins14black500(),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  subTitle ?? "",
                  style: poppins13black400(),
                ),
              ],
            )
          ]),
          Row(
            children: [
              Text(
                value,
                style: poppins13black400(),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade300,
                size: 15,
              ),
            ],
          )
        ],
      ),
    );
  }
}
