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
  final Color? buttonColor;
  final Color? borderColor;

  ButtonTemplate({
    required this.buttonName,
    required this.buttonWidth,
    required this.buttonAction,
    this.loading = false,
    this.textColor,
    this.buttonColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: loading ? () {} : buttonAction,
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
                color: textColor ?? Colors.white,
                fontSize: 12.r,
                fontWeight: FontWeight.w500,
              ),
            ),
      color: buttonColor ?? CustomColors.black,
      elevation: 2,
      minWidth: buttonWidth,
      height: 45,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: borderColor ?? Colors.transparent,
          )),
      //padding: EdgeInsets.all(15),
    );
  }
}
