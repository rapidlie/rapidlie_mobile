// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';

class TextFieldTemplate extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final bool? readOnly;
  final double width;
  final double height;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final bool enabled;
  final double leftContentPadding;
  final Color? textFieldColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int numberOfLines;
  final int? maxLength;
  final double rightContentPadding;
  final ValueChanged? onChanged;

  TextFieldTemplate({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.obscureText,
    this.readOnly,
    required this.width,
    required this.height,
    required this.textInputType,
    required this.textInputAction,
    required this.enabled,
    this.leftContentPadding = 14.0,
    this.rightContentPadding = 14.0,
    this.textFieldColor,
    this.prefixIcon,
    this.suffixIcon,
    this.numberOfLines = 1,
    this.maxLength,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          autofocus: false,
          enabled: enabled,
          maxLines: numberOfLines,
          keyboardType: textInputType,
          textInputAction: textInputAction,
          autocorrect: false,
          readOnly: readOnly ?? false,
          maxLength: maxLength,
          // The decoration now automatically inherits from the global theme
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
          onChanged: onChanged,
          // The style also inherits from the global text theme
          style: inter14black500(context),
        ),
      ),
    );
  }
}

/* 

Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
      ),
      child: Center(
        child: TextField(
          key: key,
          controller: controller,
          obscureText: obscureText,
          autofocus: false,
          enabled: enabled,
          maxLines: numberOfLines,
          keyboardType: textInputType,
          textInputAction: textInputAction,
          autocorrect: false,
          readOnly: readOnly ?? false,
          maxLength: maxLength,
          decoration: InputDecoration(
            
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.only(
              left: leftContentPadding,
              right: rightContentPadding,
              top: 10,
              bottom: 10,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: CustomColors.lightGray,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: CustomColors.gray,
              ),
            ),
            hintStyle: GoogleFonts.inter(
              color: CustomColors.hintTextColor,
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
            ),
            hintText: hintText,
          ),
          onChanged: onChanged,
          style: GoogleFonts.inter(
            color: CustomColors.black,
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

 */
