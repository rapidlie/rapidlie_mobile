import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderTextTemplate extends StatelessWidget {
  final String titleText;
  final Color titleTextColor;
  final Color? containerColor;
  final Color containerBorderColor;
  final double textSize;
  final Widget? iconWidget;
  final double? verticalPadding;
  final double? horizontalPadding;

  const HeaderTextTemplate({
    Key? key,
    required this.titleText,
    required this.titleTextColor,
    this.containerColor = const Color.fromARGB(133, 218, 218, 218),
    required this.textSize,
    this.iconWidget,
    this.containerBorderColor = const Color.fromARGB(133, 218, 218, 218),
    this.verticalPadding,
    this.horizontalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: containerColor,
        border: Border.all(
          color: containerBorderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding ?? 10,
          horizontal: horizontalPadding ?? 20,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget == null
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: iconWidget!,
                  ),
            Text(
              titleText,
              style: GoogleFonts.inter(
                fontSize: textSize,
                fontWeight: FontWeight.w600,
                color: titleTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
