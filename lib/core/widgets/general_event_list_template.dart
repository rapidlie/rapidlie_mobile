import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';

class GeneralEventListTemplate extends StatelessWidget {
  final Widget trailingWidget;
  const GeneralEventListTemplate({Key? key, required this.trailingWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: width,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pridal Rave",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Sunday",
                        style: TextStyle(
                          fontSize: 11.0,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          height: 10,
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "04.10.2024",
                        style: TextStyle(
                          fontSize: 11.0,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailingWidget
            ],
          ),
        )
      ],
    );
  }
}
