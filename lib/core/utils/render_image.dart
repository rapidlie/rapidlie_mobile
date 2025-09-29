import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RenderImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final String? placeholder;
  final Color? color;

  const RenderImage({
    Key? key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.color,
    this.placeholder = "assets/images/placeholder.png",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl.endsWith('.svg')) {
      return SvgPicture.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
        placeholderBuilder: (context) => Image.asset(
          placeholder!,
          height: height,
          width: width,
          fit: fit,
        ),
      );
    } else if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        color: color,
        placeholder: (context, url) => Image.asset(
          placeholder!,
          height: height,
          width: width,
          fit: fit,
        ),
        errorWidget: (context, url, error) => Image.asset(
          placeholder!,
          height: height,
          width: width,
          fit: fit,
        ),
      );
    } else {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        color: color,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            placeholder!,
            height: height,
            width: width,
            fit: fit,
          );
        },
      );
    }
  }
}
