import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';

class EventListTemplate extends StatelessWidget {
  const EventListTemplate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Eugene Ofori Asiedu",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Accra Business Centre",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: width,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: Colors.grey.shade300,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
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
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Icon(
                      Icons.favorite_outline_outlined,
                      color: Colors.grey.shade600,
                      size: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Icon(
                      Icons.ios_share,
                      color: Colors.grey.shade600,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
