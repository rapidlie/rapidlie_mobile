import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'color_constants.dart';

double width = Get.width;
double height = Get.height;
double borderRadius = 8.0;

bigSpacing() {
  return SizedBox(
    height: 48,
  );
}

normalSpacing() {
  return SizedBox(
    height: 32,
  );
}

smallSpacing() {
  return SizedBox(
    height: 24,
  );
}

verySmallSpacing() {
  return SizedBox(
    height: 16,
  );
}

textBoxSpace() {
  return SizedBox(
    height: 12,
  );
}

extraSmallSpacing() {
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

poppins14black500() {
  return TextStyle(
    color: ColorConstants.black,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
  );
}
