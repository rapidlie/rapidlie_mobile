import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rapidlie/constants/color_constants.dart';

class AppBarTemplate extends StatelessWidget {
  final String pageTitle;

  const AppBarTemplate({Key? key, required this.pageTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 1,
      centerTitle: true,
      title: Text(
        pageTitle,
        style: TextStyle(
          fontFamily: "Metropolis",
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
          color: ColorConstants.black,
        ),
      ),
    );
  }
}
