import 'package:flutter/material.dart';
import 'package:rapidlie/constants/color_system.dart';

class ButtonTemplate extends StatelessWidget {
  final String buttonName;
  final Color buttonColor;
  final double buttonWidth;
  final double buttonHeight;
  final Function() buttonAction;
  final Color fontColor;
  final double textSize;
  final double buttonBorderRadius;
  final bool loading;

  ButtonTemplate({
    required this.buttonName,
    required this.buttonColor,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.buttonAction,
    required this.fontColor,
    required this.textSize,
    required this.buttonBorderRadius,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: buttonAction,
      child: loading
          ? Container(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                backgroundColor: ColorSystem.white,
                strokeWidth: 1,
              ),
            )
          : Text(
              buttonName,
              style: TextStyle(
                color: fontColor,
                fontSize: 16.0,
                fontFamily: 'Metropolis',
                fontWeight: FontWeight.w500,
              ),
            ),
      color: buttonColor,
      splashColor: Colors.green,
      elevation: 2,
      minWidth: buttonWidth,
      height: 50,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonBorderRadius)),
      padding: EdgeInsets.all(15),
    );
  }
}
