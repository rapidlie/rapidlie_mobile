import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';
import 'package:rapidlie/core/widgets/header_title_template.dart';

class ExploreCategoryListTemplate extends StatelessWidget {
  final String categoryName;
  final String imageSrc;

  const ExploreCategoryListTemplate(
      {Key? key, required this.categoryName, required this.imageSrc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Container(
        child: Column(
          children: [
            /* Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: CustomColors.lightGray, shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                    child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/placeholder.png',
                  image: imageSrc,
                  height: 10,
                  width: 10,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                        'assets/images/error.png'); // Fallback image on error
                  },
                )),
              ),
            ), */
            HeaderTextTemplate(
              titleText: categoryName,
              titleTextColor: Colors.black,
              containerColor: CustomColors.white,
              containerBorderColor: CustomColors.gray,
              textSize: 12,
            )
            /* Text(
              categoryName,
              softWrap: false,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CustomColors.black,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                fontSize: 10.0,
                overflow: TextOverflow.fade,
              ), 
            )*/
          ],
        ),
      ),
    );
  }
}
