import 'package:flutter/material.dart';
import 'package:rapidlie/components/button_template.dart';
import 'package:rapidlie/constants/color_system.dart';
import 'package:rapidlie/views/auth/signup_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "home";
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              height: height,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: ColorSystem.secondary,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Hi, Eugene',
                              style: TextStyle(
                                color: ColorSystem.white,
                                fontSize: 20.0,
                                fontFamily: "Metropolis",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              child: Icon(
                                Icons.add_circle_rounded,
                                color: ColorSystem.secondary,
                                size: 40,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              child: Icon(
                                Icons.qr_code_2_rounded,
                                color: ColorSystem.secondary,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: ColorSystem.gray,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Feeling unsage? Get tracked!',
                            style: TextStyle(
                                color: ColorSystem.primary,
                                fontSize: 18.0,
                                fontFamily: "Metroplis",
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 50.0),
                            child: ButtonTemplate(
                              buttonName: "Get tracked",
                              buttonColor: ColorSystem.secondary,
                              buttonWidth: width,
                              buttonHeight: 50,
                              buttonAction: () {
                                Navigator.pushNamed(
                                    context, SignupScreen.routeName);
                              },
                              fontColor: ColorSystem.white,
                              textSize: 14,
                              buttonBorderRadius: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
