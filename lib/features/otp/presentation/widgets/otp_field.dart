import 'package:flutter/material.dart';

import 'package:rapidlie/core/constants/color_constants.dart';

class OtpField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final Function(String) otpListener;

  const OtpField({
    Key? key,
    required this.focusNode,
    required this.controller,
    required this.otpListener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
        ),
        child: TextField(
          textAlign: TextAlign.center,
          onChanged: otpListener,
          keyboardType: TextInputType.number,
          maxLines: 1,
          maxLength: 1,
          controller: controller,
          obscureText: false,
          autofocus: true,
          enabled: true,
          focusNode: focusNode,
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
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
          ),
          style: TextStyle(
            color: ColorConstants.black,
            fontSize: 14.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
