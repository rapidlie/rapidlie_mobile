import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';

class ExploreCategoryListTemplate extends StatelessWidget {
  final String categoryName;

  const ExploreCategoryListTemplate({Key? key, required this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: const Color.fromARGB(255, 138, 81, 81),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            categoryName,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 14.0,
              color: Color.fromARGB(133, 63, 59, 59),
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
