import 'package:flutter/material.dart';

class HeaderTextTemplate extends StatelessWidget {
  final String titleText;
  final Color titleTextColor;
  final Color containerColor;
  final double textSize;

  const HeaderTextTemplate(
      {Key? key,
      required this.titleText,
      required this.titleTextColor,
      required this.containerColor,
      required this.textSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: containerColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          titleText,
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
            color: titleTextColor,
          ),
        ),
      ),
    );
  }
}
