import 'package:flutter/material.dart';
import 'package:rapidlie/components/button_template.dart';
import 'package:rapidlie/constants/color_system.dart';

import '../views/auth/signup_screen.dart';

class HomepageActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.16,
      width: width * 0.76,
      decoration: BoxDecoration(
        //color: ColorSystem.unsafeBoxColor,
        color: Color.fromARGB(255, 213, 179, 77).withOpacity(0.3),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                //child: Image.asset(""),
                ),
            Text(
              'Feeling unsage? Get tracked!',
              style: TextStyle(
                  color: ColorSystem.black,
                  fontSize: 14.0,
                  fontFamily: "Metroplis",
                  fontWeight: FontWeight.w500),
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
