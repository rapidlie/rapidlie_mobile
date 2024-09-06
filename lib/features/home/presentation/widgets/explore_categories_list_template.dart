import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/color_constants.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';

class ExploreCategoryListTemplate extends StatelessWidget {
  final String categoryName;
  final String imageSrc;

  const ExploreCategoryListTemplate(
      {Key? key, required this.categoryName, required this.imageSrc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Container(
        width: 80,
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                color: ColorConstants.lightGray,
              ),
              child: ClipRRect(
                  child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/placeholder.png',
                image: imageSrc,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                      'assets/images/error.png'); // Fallback image on error
                },
              )),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              categoryName,
              softWrap: false,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorConstants.black,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                fontSize: 13.0,
                overflow: TextOverflow.fade,
              ),
            )
          ],
        ),
      ),
    );
  }
}



/* 

FadeInImage.assetNetwork(
    placeholder: 'assets/images/placeholder.png', // Local placeholder image
    image: category.image,
    imageErrorBuilder: (context, error, stackTrace) {
      return Image.asset('assets/images/error.png'); // Fallback image on error
    },

 */