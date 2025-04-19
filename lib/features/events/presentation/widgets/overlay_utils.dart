import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';


class OverlayUtils {
  static OverlayEntry createOverlayEntry(
    Widget overlayToOpen,
    Offset buttonPosition,
    Size buttonSize,
    double? left,
    double width,
    double? right,
  ) {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy + buttonSize.height,
          left: left,
          right: right,
          width: width,
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: overlayToOpen,
              ),
            ),
          ),
        );
      },
    );
  }
}
