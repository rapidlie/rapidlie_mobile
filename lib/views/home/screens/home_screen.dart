import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/color_constants.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "home";

  final List<String> imageSet = [
    "assets/images/unsafe.png",
    "assets/images/unsafe.png",
    "assets/images/unsafe.png"
  ];

  final List<String> textSet = [
    "Feeling unsafe?",
    "Feeling unsafe?",
    "Feeling unsafe?"
  ];

  final List<String> subtextSet = ["Get tracked", "Get tracked", "Get tracked"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              height: height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hi, Eugene',
                          style: TextStyle(
                            color: ColorConstants.black,
                            fontSize: 22.0,
                            fontFamily: "Metropolis",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.add,
                              size: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.filter_alt_outlined,
                              size: 30,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  Row(
                    children: [],
                  ),
                  SizedBox(
                    height: 48,
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
