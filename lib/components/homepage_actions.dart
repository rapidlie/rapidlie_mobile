// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:rapidlie/constants/color_constants.dart';

class HomepageActions extends StatelessWidget {
  final Color color;
  final String imageSource;
  final String mainText;
  final String subText;

  const HomepageActions({
    Key? key,
    required this.color,
    required this.imageSource,
    required this.mainText,
    required this.subText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.16,
      width: width * 0.76,
      decoration: BoxDecoration(
        //color: ColorSystem.unsafeBoxColor,
        //color: Color.fromARGB(255, 213, 179, 77).withOpacity(0.3),
        color: color,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Image.asset(imageSource),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      mainText,
                      style: TextStyle(
                          color: ColorConstants.black,
                          fontSize: 14.0,
                          fontFamily: "Metroplis",
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      subText,
                      style: TextStyle(
                          color: ColorConstants.black,
                          fontSize: 14.0,
                          fontFamily: "Metroplis",
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}
