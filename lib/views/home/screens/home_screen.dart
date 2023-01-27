import 'package:flutter/material.dart';
import 'package:rapidlie/components/homepage_actions.dart';
import 'package:rapidlie/constants/color_constants.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "home";

  List<String> imageSet = [
    "assets/images/unsafe.png",
    "assets/images/unsafe.png",
    "assets/images/unsafe.png"
  ];

  List<String> textSet = [
    "Feeling unsafe?",
    "Feeling unsafe?",
    "Feeling unsafe?"
  ];

  List<String> subtextSet = ["Get tracked", "Get tracked", "Get tracked"];

  List<Color> colorSet = [
    ColorConstants.unsafeBoxColor,
    ColorConstants.addFriendsBoxColor,
    Color.fromARGB(255, 213, 179, 77).withOpacity(0.3)
  ];

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'rapidlie.',
                          style: TextStyle(
                            color: ColorConstants.black,
                            fontSize: 22.0,
                            fontFamily: "Metropolis",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: ColorConstants.black,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: height * 0.24,
                        width: width,
                        child: ListView.separated(
                          padding: EdgeInsets.only(left: 20),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return HomepageActions(
                              color: colorSet[index],
                              imageSource: imageSet[index],
                              mainText: textSet[index],
                              subText: subtextSet[index],
                            );
                          },
                          itemCount: 3,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              width: 20,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 48,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Summary",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: "Metropolis",
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: width,
                    height: height * 0.25,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
