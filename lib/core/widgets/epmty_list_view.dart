import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget emptyStateFullView({required String headerText, required String bodyText}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Image.asset(
          "assets/images/empty_list.png",
          cacheHeight: 741,
          cacheWidth: 1146,
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Text(
        headerText,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5),
        child: Text(
          bodyText,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      )
    ],
  );
}

Widget emptyStateSingleView(String headerText, String bodyText) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    //mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Image.asset(
          "assets/images/empty_view.png",
          cacheHeight: 741,
          cacheWidth: 1146,
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Text(
        "No events",
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5),
        child: Text(
          "Get started by hitting the button on the bottom right corner of your screen. It is easy",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      )
    ],
  );
}
