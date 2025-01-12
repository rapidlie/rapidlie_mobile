import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderTextTemplate extends StatelessWidget {
  final String titleText;
  final Color titleTextColor;
  final Color containerColor;
  final Color? containerBorderColor;
  final double textSize;
  final Widget? iconWidget;
  final double? verticalPadding;
  final double? horizontalPadding;

  const HeaderTextTemplate({
    Key? key,
    required this.titleText,
    required this.titleTextColor,
    required this.containerColor,
    required this.textSize,
    this.iconWidget,
    this.containerBorderColor,
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
          color: containerBorderColor ?? containerColor,
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
