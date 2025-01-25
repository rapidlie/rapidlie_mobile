import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_colors.dart';

double width = Get.width.w;
double height = Get.height.h;
double borderRadius = 8.r;

bigHeight() {
  return SizedBox(
    height: 48.h,
  );
}

normalHeight() {
  return SizedBox(
    height: 32.h,
  );
}

smallHeight() {
  return SizedBox(
    height: 24.h,
  );
}

verySmallHeight() {
  return SizedBox(
    height: 16.h,
  );
}

textBoxSpace() {
  return SizedBox(
    height: 12.h,
  );
}

extraSmallHeight() {
  return SizedBox(
    height: 5.h,
  );
}

poppins13black400() {
  return GoogleFonts.inter(
    color: CustomColors.black,
    fontWeight: FontWeight.w400,
    fontSize: 13.0,
  );
}

poppins10black400() {
  return GoogleFonts.inter(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
}

poppins12black400() {
  return GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
}

poppins11black600() {
  return GoogleFonts.inter(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
}

poppins10white400() {
  return GoogleFonts.inter(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
}

poppins10white500() {
  return GoogleFonts.inter(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

poppins14black500() {
  return GoogleFonts.inter(
    color: CustomColors.black,
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
  );
}

inter15black500() {
  return GoogleFonts.inter(
    color: CustomColors.black,
    fontWeight: FontWeight.w500,
    fontSize: 15.sp,
  );
}

inter14black600() {
  return GoogleFonts.inter(
    color: CustomColors.black,
    fontWeight: FontWeight.w600,
    fontSize: 14.sp,
  );
}

mainAppbarTitleStyle() {
  return GoogleFonts.inter(
    color: Colors.black,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
  );
}

inter14CharcoalBlack400() {
  return GoogleFonts.inter(
    fontSize: 14.sp,
    color: CustomColors.charcoalBlack,
    fontWeight: FontWeight.w400,
  );
}

inter12CharcoalBlack400() {
  return GoogleFonts.inter(
    fontSize: 12.sp,
    color: CustomColors.charcoalBlack,
    fontWeight: FontWeight.w400,
  );
}

inter10CharcoalBlack400() {
  return GoogleFonts.inter(
    fontSize: 10.sp,
    color: CustomColors.charcoalBlack,
    fontWeight: FontWeight.w400,
  );
}

inter12CharcoalBlack500() {
  return GoogleFonts.inter(
    fontSize: 12.sp,
    color: CustomColors.charcoalBlack,
    fontWeight: FontWeight.w500,
  );
}

inter12Red500() {
  return GoogleFonts.inter(
    fontSize: 12.sp,
    color: Colors.red,
    fontWeight: FontWeight.w500,
  );
}

subAppbarTitleStyle() {
  return GoogleFonts.inter(
    color: Colors.black,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );
}
