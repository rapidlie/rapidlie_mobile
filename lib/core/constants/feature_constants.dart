import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


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

inter13black400(BuildContext context) {
  return GoogleFonts.inter(
    color: Theme.of(context).colorScheme.onSurface,
    fontWeight: FontWeight.w400,
    fontSize: 13.sp,
  );
}

inter13black500(BuildContext context) {
  return GoogleFonts.inter(
    color: Theme.of(context).colorScheme.onSurface,
    fontWeight: FontWeight.w500,
    fontSize: 13.sp,
  );
}

inter10black400(BuildContext context) {
  return GoogleFonts.inter(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
  );
}

inter12black400(BuildContext context) {
  return GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
  );
}

inter12Black600(BuildContext context) {
  return GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
  );
}

inter11black600(BuildContext context) {
  return GoogleFonts.inter(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
  );
}

inter10white400(BuildContext context) {
  return GoogleFonts.inter(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.surface,
  );
}

inter10white500(BuildContext context) {
  return GoogleFonts.inter(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).colorScheme.surface,
  );
}

inter14black500(BuildContext context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
    color: Theme.of(context).colorScheme.onSurface,
  );
}

inter15black500(BuildContext context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 15.sp,
    color: Theme.of(context).colorScheme.onSurface,
  );
}

inter14black600(BuildContext context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 14.sp,
    color: Theme.of(context).colorScheme.onSurface,
  );
}

inter14Orange500(BuildContext context) {
  return GoogleFonts.inter(
    color: Colors.deepOrange,
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
  );
}

mainAppbarTitleStyle(BuildContext context) {
  return GoogleFonts.inter(
    color: Theme.of(context).colorScheme.onSurface,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    textStyle: TextStyle(overflow: TextOverflow.ellipsis),
  );
}

inter14Black400(BuildContext context) {
  return GoogleFonts.inter(
    fontSize: 14.sp,
    color: Theme.of(context).colorScheme.onSurface,
    fontWeight: FontWeight.w400,
  );
}

inter12Black400(BuildContext context) {
  return GoogleFonts.inter(
    fontSize: 12.sp,
    color: Theme.of(context).colorScheme.onSurface,
    fontWeight: FontWeight.w400,
  );
}

inter16Black500(BuildContext context) {
  return GoogleFonts.inter(
    fontSize: 16.sp,
    color: Theme.of(context).colorScheme.onSurface,
    fontWeight: FontWeight.w500,
  );
}

inter16Black600(BuildContext context) {
  return GoogleFonts.inter(
    fontSize: 16.sp,
    color: Theme.of(context).colorScheme.onSurface,
    fontWeight: FontWeight.w600,
  );
}

inter10Black400(BuildContext context) {
  return GoogleFonts.inter(
    fontSize: 10.sp,
    color: Theme.of(context).colorScheme.onSurface,
    fontWeight: FontWeight.w400,
  );
}

inter12Black500(BuildContext context) {
  return GoogleFonts.inter(
    fontSize: 12.sp,
    color: Theme.of(context).colorScheme.onSurface,
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

subAppbarTitleStyle(BuildContext context) {
  return GoogleFonts.inter(
    color: Theme.of(context).colorScheme.onSurface,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );
}
