import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';
import 'package:shimmer/shimmer.dart';

/* Widget emptyStateFullView(
    {required String headerText, required String bodyText}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Image.asset(
          "assets/images/empty_list.png",
          cacheHeight: 741,
          cacheWidth: 1146,
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Text(
        headerText,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5),
        child: Text(
          bodyText,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      )
    ],
  );
} */

Widget emptyStateView() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    //mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          //height: height * 0.45,
          child: Image.asset(
            "assets/images/empty_list.png",
            cacheHeight: 603,
            cacheWidth: 1026,
          ),
        ),
      ),
    ],
  );
}

Widget emptyStateCategoryView() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    //mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          //height: height * 0.45,
          child: Image.asset(
            "assets/images/empty_category_view.png",
            cacheHeight: 603,
            cacheWidth: 1026,
          ),
        ),
      ),
    ],
  );
}

Widget emptyListView() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: CustomColors.lightGray,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 16,
                    width: 200,
                    decoration: BoxDecoration(
                      color: CustomColors.lightGray,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
              Icon(Icons.favorite, color: CustomColors.lightGray),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 18,
          width: 120,
          decoration: BoxDecoration(
            color: CustomColors.lightGray,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        SizedBox(height: 5),
        Container(
          height: 12,
          width: double.infinity,
          decoration: BoxDecoration(
            color: CustomColors.lightGray,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        SizedBox(height: 5),
        Container(
          height: 12,
          width: double.infinity,
          decoration: BoxDecoration(
            color: CustomColors.lightGray,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        SizedBox(height: 5),
        Icon(Icons.star, color: CustomColors.lightGray),
      ],
    ),
  );
}

Widget emptyListWithShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: 16,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
                Icon(Icons.favorite, color: Colors.white),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 18,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 5),
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 5),
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 5),
          Icon(Icons.star, color: Colors.white),
        ],
      ),
    ),
  );
}
