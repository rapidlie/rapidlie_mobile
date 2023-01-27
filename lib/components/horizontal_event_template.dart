import 'package:flutter/material.dart';
import 'package:rapidlie/constants/color_constants.dart';

class HorizontalEventTemplate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Card(
        elevation: 1.0,
        child: Container(
          width: width * 0.65,
          decoration: BoxDecoration(
            color: ColorConstants.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset("assets/images/wed.jpg"),
              ),
              Text(
                "Andy's Wedding",
                style: TextStyle(
                    color: ColorConstants.secondary,
                    fontSize: 13.0,
                    fontFamily: "Metropolis",
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ),
    );
  }
}
