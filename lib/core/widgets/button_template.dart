import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';

class ButtonTemplate extends StatelessWidget {
  final String buttonName;
  final double buttonWidth;
  final Function() buttonAction;
  final bool loading;
  final Color? textColor;

  ButtonTemplate({
    required this.buttonName,
    required this.buttonWidth,
    required this.buttonAction,
    this.loading = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: buttonAction,
      child: loading
          ? Container(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                backgroundColor: CustomColors.white,
                strokeWidth: 1,
              ),
            )
          : Text(
              buttonName.toUpperCase(),
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 13.r,
                fontWeight: FontWeight.w800,
              ),
            ),
      color: CustomColors.black,
      elevation: 1,
      minWidth: buttonWidth,
      height: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      //padding: EdgeInsets.all(15),
    );
  }
}
