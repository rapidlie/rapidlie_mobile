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

  TextFieldTemplate({
    required this.hintText,
    required this.controller,
    required this.obscureText,
    required this.width,
    required this.height,
    required this.textInputType,
    required this.textInputAction,
    required this.enabled,
    this.leftContentPadding = 14.0,
    this.textFieldColor,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: textFieldColor ?? ColorConstants.lightGray,
      ),
      child: Center(
        child: TextField(
          key: key,
          controller: controller,
          obscureText: obscureText,
          autofocus: false,
          enabled: enabled,
          maxLines: 1,
          keyboardType: textInputType,
          textInputAction: textInputAction,
          autocorrect: false,
          readOnly: readOnly ?? false,
          decoration: InputDecoration(
            counterText: '',
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.only(
              left: leftContentPadding,
              right: 14.0,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: ColorConstants.colorFromHex("#C6CDD3"),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: ColorConstants.primary,
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
