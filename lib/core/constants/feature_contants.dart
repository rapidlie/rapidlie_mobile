import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
