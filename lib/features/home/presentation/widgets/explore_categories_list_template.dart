import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';
import 'package:rapidlie/core/utils/render_image.dart';
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
            HeaderTextTemplate(
              titleText: categoryName,
              titleTextColor: Theme.of(context).colorScheme.primary,
              containerColor: Theme.of(context).colorScheme.surface,
              containerBorderColor: CustomColors.gray,
              textSize: 12,
              iconWidget: RenderImage(
                imageUrl: imageSrc,
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          ],
        ),
      ),
    );
  }
}
