import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'color_constants.dart';

double width = Get.width;
double height = Get.height;
double borderRadius = 8.0;

bigHeight() {
  return SizedBox(
    height: 48,
  );
}

normalHeight() {
  return SizedBox(
    height: 32,
  );
}

smallHeight() {
  return SizedBox(
    height: 24,
  );
}

verySmallHeight() {
  return SizedBox(
    height: 16,
  );
}

textBoxSpace() {
  return SizedBox(
    height: 12,
  );
}

extraSmallHeight() {
  return SizedBox(
    height: 8,
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
    fontSize: 10.0,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
}

poppins14black500() {
  return TextStyle(
    color: ColorConstants.black,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
  );
}

mainAppbarTitleStyle() {
  return TextStyle(
    color: Colors.black,
    fontSize: 20.0,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w600,
  );
}

poppins14CharcoalBlack400() {
  return TextStyle(
    fontSize: 14.0,
    color: ColorConstants.charcoalBlack,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
}

poppins12CharcoalBlack500() {
  return TextStyle(
    fontSize: 12.0,
    color: ColorConstants.charcoalBlack,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
  );
}

subAppbarTitleStyle() {
  return TextStyle(
    color: Colors.black,
    fontSize: 18.0,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w500,
  );
}
