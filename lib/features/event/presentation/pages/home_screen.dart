import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/color_constants.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';
import 'package:rapidlie/core/widgets/header_title_template.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "home";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20, top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hi, Eugene',
                  style: TextStyle(
                    color: ColorConstants.black,
                    fontSize: 22.0,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
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
        ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: HeaderTextTemplate(
                        titleText: "UPCOMING EVENTS",
                        titleTextColor: Colors.black,
                        containerColor: Color.fromARGB(133, 218, 218, 218),
                        textSize: 13,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0,
                      ),
                      child: Container(
                        width: width,
                        height: height * 0.25,
                        child: ListView.builder(
                          itemCount: 3,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(left: 20),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Container(
                                width: width * 0.85,
                                height: height * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                  color: const Color.fromARGB(255, 138, 81, 81),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    normalSpacing(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: HeaderTextTemplate(
                        titleText: "DISCOVER",
                        titleTextColor: Colors.black,
                        containerColor: Color.fromARGB(133, 218, 218, 218),
                        textSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
