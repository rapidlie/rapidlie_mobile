import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'color_constants.dart';

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
    height: 8.h,
  );
}

poppins13black400() {
  return TextStyle(
    color: ColorConstants.black,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w400,
    fontSize: 13.0,
  );
}

poppins10black400() {
  return TextStyle(
    fontSize: 10.sp,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
}

poppins10white400() {
  return TextStyle(
    fontSize: 10.sp,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
}

poppins10white500() {
  return TextStyle(
    fontSize: 10.sp,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

poppins14black500() {
  return TextStyle(
    color: ColorConstants.black,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
  );
}

poppins15black500() {
  return TextStyle(
    color: ColorConstants.black,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w500,
    fontSize: 15.sp,
  );
}

mainAppbarTitleStyle() {
  return TextStyle(
    color: Colors.black,
    fontSize: 20.sp,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w600,
  );
}

poppins14CharcoalBlack400() {
  return TextStyle(
    fontSize: 14.sp,
    color: ColorConstants.charcoalBlack,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
}

poppins12CharcoalBlack500() {
  return TextStyle(
    fontSize: 12.sp,
    color: ColorConstants.charcoalBlack,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
  );
}

subAppbarTitleStyle() {
  return TextStyle(
    color: Colors.black,
    fontSize: 18.sp,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w500,
  );
}
