import 'package:flutter/material.dart';

class HeaderTextTemplate extends StatelessWidget {
  final String titleText;
  final Color titleTextColor;
  final Color containerColor;
  final double textSize;
  final Widget? iconWidget;

  const HeaderTextTemplate({
    Key? key,
    required this.titleText,
    required this.titleTextColor,
    required this.containerColor,
    required this.textSize,
    this.iconWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: containerColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget == null
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: iconWidget!,
                  ),
            Text(
              titleText,
              style: TextStyle(
                fontSize: textSize,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
                color: titleTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
