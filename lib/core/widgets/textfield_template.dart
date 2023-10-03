// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

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
    this.textFieldColor,
    this.prefixIcon,
    this.suffixIcon,
    this.numberOfLines = 1,
    this.maxLength,
  }) : super(key: key);

  @override
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
            //counterText: null,
            //counter: ,
            /*  counterStyle: TextStyle(
              fontSize: 12,
              fontFamily: "Poppins",
              color: ColorConstants.primary,
              fontWeight: FontWeight.w500,
            ), */
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.only(
              left: leftContentPadding,
              right: 14.0,
              top: 10,
              bottom: 10,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: ColorConstants.black,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: ColorConstants.black,
              ),
            ),
            hintStyle: TextStyle(
              color: ColorConstants.hintTextColor,
              fontSize: 14.0,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
            hintText: hintText,
          ),
          style: TextStyle(
            color: ColorConstants.black,
            fontSize: 17.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
