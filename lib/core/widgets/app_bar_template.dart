import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapidlie/core/constants/color_constants.dart';

class AppBarTemplate extends StatelessWidget {
  final String pageTitle;

  const AppBarTemplate({Key? key, required this.pageTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Icon(
          Icons.arrow_back,
          color: ColorConstants.black,
        ),
      ),
      title: Text(
        pageTitle,
        style: TextStyle(
          fontFamily: "Poppins",
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
          color: ColorConstants.black,
        ),
      ),
    );
  }
}
