import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/color_constants.dart';

class ButtonTemplate extends StatelessWidget {
  final String buttonName;

  final double buttonWidth;

  final Function() buttonAction;

  final bool loading;

  ButtonTemplate({
    required this.buttonName,
    required this.buttonWidth,
    required this.buttonAction,
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
                backgroundColor: ColorConstants.white,
                strokeWidth: 1,
              ),
            )
          : Text(
              buttonName.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
      color: Colors.black,
      splashColor: Colors.black45,
      elevation: 1,
      minWidth: buttonWidth,
      height: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.all(15),
    );
  }
}
